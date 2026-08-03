

# MiniDefender

Un enfoque pragmático para la validación en Rails inspirado en el Validator de Laravel.


## Instalación

Instala la gem y añádela al Gemfile de la aplicación ejecutando:

    $ bundle add mini_defender

Si no se usa bundler para gestionar las dependencias, instala la gem ejecutando:

    $ gem install mini_defender


## Uso

Mini Defender permite al desarrollador validar rápidamente y fácilmente los datos de las solicitudes entrantes como primer paso de verificación en la solicitud. Además, Mini Defender también ofrece los siguientes beneficios:

- Lógica de validación concisa y fácil de escribir
- Validar estructuras de datos complejas y anidadas
- Más de 80 reglas de validación disponibles
- Reglas de validación personalizadas

La forma más fácil de usar Mini Defender es incluir el concern `MiniDefender::ValidatesInput` en tu `ApplicationController` de la siguiente manera:

```ruby
class ApplicationController < ActionController::Base
  include MiniDefender::ValidatesInput
end
```

Ahora tendrás acceso a un método llamado `validate!` que aceptará un hash de claves y sus reglas respectivas.

```ruby
# frozen_string_literal: true
class BooksController < ActionController::Base
  def create
    Book.create!(book_params)
  end
  
  private
  
  def book_params
    # Optional if you need easy access to rule definitions
    rules = MiniDefender::Rules
    
    validate!({
        'name' => 'string|required|max:255',
        'type' => ['string', rules::In.new(Book::TYPES)],
        'tags' => 'array',
        'tags.*' => 'required|string|max:255',
        'pages' => 'required|integer',
        'author' => 'required|hash',
        'author.name' => 'required|string',
        'author.email' => 'email',
    }, true)
  end
end
```

El método `validate!` acepta dos argumentos: el primero es un hash de claves y reglas, y el segundo es un booleano para indicar si deseas que los valores sean convertidos al tipo indicado por la regla, es decir, `integer`.

Supongamos que enviamos la siguiente entrada a nuestra aplicación:

```json
{
  "name": "The Story of Some Guy",
  "type": "Biography",
  "tags": ["inspiring", "business"],
  "pages": "200",
  "author": {
    "name": "Some Guy himself",
    "random_field": "hello i can haz hakc?"
  }
}
```

Observa que hemos pasado una cadena `"200"` a page en lugar de `200` y añadido un campo extra a `author` llamado `random_field`. Tampoco proporcionamos un campo `email`.

La validación superará (pasará), ya que `email` no es opcional, y obtendremos el siguiente `Hash` como resultado:

```Ruby
{
  'name' => 'The Story of Some Guy',
  'type' => 'Biography',
  'tags' => %w[inspiring business],
  'pages' => 200,
  'author' => {
    'name' => 'Some Guy himself'
  }
}
```

Puedes ver que `pages` tiene el valor convertido a `200` (integer), ya que elegimos aplicar la coerción pasando `true` a `validate!`.
También puedes ver que Mini Defender omitió la clave `random_field` ya que no formaba parte de nuestras validaciones.


## Renderizado de Errores

Cuando la validación falle, se levantará un error de tipo `MiniDefender::ValidationError`.

Puedes manejar el error usando `rescue` o añadir un `rescue_from` global para gestionar los errores en toda la aplicación.


## Fuera de un Controlador

El método `validate!` son en realidad las siguientes cuatro líneas de código:

```ruby
def validate!(rules, coerced = false)
    data = params.to_unsafe_hash.deep_stringify_keys
    validator = MiniDefender::Validator.new(rules, data)
    validator.validate!
    coerced ? validator.coerced : validator.data
end
```

Puedes usar Mini Defender fuera del controlador creando una nueva instancia de `MiniDefender::Validator` y llamando a cualquiera de sus métodos, consulta [validator.rb](./lib/mini_defender/validator.rb) para ver la API.
 

## Reglas

Mini Defender intenta implementar el mismo conjunto de reglas proporcionadas por Laravel, puedes ver las reglas disponibles aquí en [lib/mini_defender/rules](./lib/mini_defender/rules)


## Añadir una Regla Personalizada

Para implementar tus reglas personalizadas, necesitas crear una nueva clase que herede de `MiniDefender::Rule` e implementar al menos lo siguiente:

```ruby
class MyAwesomeRule < MiniDefender::Rule
  def self.signature
    'all_caps'
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && /^[A-Z]+$/.match?(value)
  end

  def message(attribute, value, validator)
    'ONLY CAPS ALLOWED!!!'
  end
end
```

Después de crear la clase, puedes registrarla de la siguiente manera:

```ruby
MiniDefender::RulesFactory.register(MyAwesomeRule)
```


## Contribución

Los informes de errores y las pull requests son bienvenidos en GitHub en https://github.com/ahoshaiyan/mini_defender.

## Licencia

La gem está disponible como código abierto bajo los términos de la [MIT License](./LICENSE.md).
