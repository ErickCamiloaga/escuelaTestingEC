Feature: Automatizar el backend de Pet Store

  Background:
    * url 'https://petstore.swagger.io/v2/'

  @TEST-1
  Scenario: Verificar la creación de una nueva mascota en Pet Store - OK

    * def petCreation =
  """
  {
    "id": #(Math.floor(Math.random()*100000)),
    "category": {
      "id": 1,
      "name": "dogs"
    },
    "name": "doggie",
    "photoUrls": ["photo1"],
    "tags": [
      {
        "id": 1,
        "name": "friendly"
      }
    ],
    "status": "available"
  }
  """

    Given path 'pet'
    And request petCreation
    When method post
    Then status 200
    And match response.name == 'doggie'
    And match response.status == 'available'
    And print response

  @TEST-2
  Scenario: Verificar el estado de la mascota que se ha creaado anteriormente - OK

    * def petCreation =
      """
{
    "id": 9223372036854775807,
    "category": {
        "id": 0,
        "name": "string"
    },
    "name": "doggie",
    "photoUrls": [
        "string"
    ],
    "tags": [
        {
            "id": 0,
            "name": "string"
        }
    ],
    "status": "available"
}
      """

    Given path 'pet/findByStatus'
    And  param status = 'available'
    When method get
    Then status 200
    And print response

  @TEST-3
  Scenario Outline: Buscar por estado

    Given path 'pet', 'findByStatus'
    And param status = '<status>'
    When method get
    Then status 200

    Examples:
      | status    |
      | available |
      | pending   |
      | sold      |

  @TEST-4
  Scenario: Actualizar mascota en Pet Store -OK

    * def petCreation =
      """
{
    "id": 9223372036854775807,
    "category": {
        "id": 1,
        "name": "string"
    },
    "name": "Max",
    "photoUrls": [
        "string"
    ],
    "tags": [
        {
            "id": 0,
            "name": "string"
        }
    ],
    "status": "available"
}
      """

    Given path 'pet'
    And request petCreation
    When method post
    Then status 200
    And print response

  @TEST-5
  Scenario Outline: Verificar mascota por id - OK

    Given path 'pet/', + '<idPet>'
    When method get
    Then status 200
    And print response

    Examples:
      | idPet |
      | 1     |
      | 2     |
      | 3     |

  @TEST-6
  Scenario Outline: Verificar mascota por id - OK

    Given path 'pet/', + '<idPet>'
    When method delete
    Then status 200
    And print response

    Examples:
      | idPet |
      | 1     |
      | 2     |
      | 3     |

  @TEST-7
  Scenario: Subir una imagen para una mascota existente
    * def petId = 1

    Given path 'pet', petId, 'uploadImage'
    And multipart file file = { read: 'bugs.jpg', filename: 'bugs.jpg', contentType: 'image/jpeg' }
    And multipart field additionalMetadata = 'Foto de perfil actualizada'
    When method post
    Then status 200
    And match response.message contains 'bugs.jpg'


  # mvn clean test -Dtest=UsersRunner -Dkarate.options="--tags @TEST-1" -Dkarate.env=cert
  # mvn clean test -Dtest=UsersRunner -Dkarate.options="--tags @TEST-1"