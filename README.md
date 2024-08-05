# buscareferencia

- `lib/`
    - `main.dart`: Arquivo principal que inicia o aplicativo.
    - `api_service.dart`: Serviço para realizar requisições HTTP.
    - `search_address_screen.dart`: Tela para pesquisa de endereços.
    - `map_screen.dart`: Tela que exibe o mapa e os marcadores.
    - `marker.dart`: Serviço para criar marcadores no mapa.
    - `geolocator_service.dart`: Serviço para obter a localização atual do usuário.
    - `helpers.dart`: Funções auxiliares, como encontrar a parada mais próxima.
    - `models/`
        - `address.dart`: Modelo de dados para o endereço.
        - `stop.dart`: Modelo de dados para as paradas e serviço para buscar paradas.
## Getting Started

#### Uso

1. **Tela de Pesquisa de Endereço** (`search_address_screen.dart`):
    - Permite que o usuário pesquise um endereço na região de Brasília.
    - Utiliza a API do Nominatim para obter os resultados da pesquisa.

2. **Tela do Mapa** (`map_screen.dart`):
    - Exibe o mapa usando OpenStreetMap.
    - Mostra a localização atual do usuário.
    - Exibe marcadores das paradas de ônibus próximas.
    - Destaca a parada mais próxima do usuário e do destino selecionado.

3. **Serviço de Paradas** (`stop.dart`):
    - Busca dados de paradas de ônibus da API do DFTrans.
    - Converte os dados JSON recebidos em instâncias do modelo `Stop`.

4. **Serviço de Marcadores** (`marker.dart`):
    - Cria marcadores a partir dos dados das paradas e endereços.


---
- `main.dart`: É o arquivo principal do projeto, que define a aplicação Flutter e suas rotas.
- `models/address.dart`: Define a classe `Address` que representa um endereço com latitude, longitude e nome de exibição.
- `address/marker.dart`: Define a classe `MarkerService` que cria marcadores para o mapa.
- `address/stop.dart`: Define a classe `StopService` que faz uma requisição à API para obter os marcadores de paradas.
- `screens/map_screen.dart`: É a tela do mapa que exibe os marcadores de paradas e a localização do usuário.
- `screens/search_address_screen.dart`: É a tela de busca de endereços que permite ao usuário pesquisar um endereço e selecioná-lo.
- `services/api_service.dart`: Define a classe `ApiService` que faz uma requisição à API Nominatim para obter os endereços.
- `services/geolocator_service.dart`: Define a classe `GeolocatorService` que obtém a localização atual do usuário.
- `utils/helpers.dart`: Define a classe `Helpers` que contém funções auxiliares, incluindo a função `findNearestMarker` que calcula a distância entre dois pontos no mapa.