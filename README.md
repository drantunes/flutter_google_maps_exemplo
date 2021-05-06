# Flutter Google Maps

Aplicativo de exemplo para simular a geolocalização de um usuário que deseja procurar cafeterias nas proximidades. 
O projeto conta com recursos de geolocalização, google maps e filtros de busca (raio de proximidade) usando o Firebase Firestore. 

## Como executar o projeto?

- Configurar um projeto no Firebase e alterar no projeto em `.firebaserc` ([documentação](https://firebase.flutter.dev/docs/overview))
- Habilitar o SDK do Google Maps para Android e iOS.
- Gerar as credenciais (API keys) no Console do Google Cloud para o projeto.
- Atualizar o `android/app/src/main/AndroidManifest.xml` com sua chave de API.
- Atualizar o `ios/Runner/AppDelegate.swift` com sua chave de API.
- Configurar as chaves de API conforme a [documentação](https://pub.dev/packages/google_maps_flutter).
- Instalar os packages com o comando `flutter pub get`.

- Salvar os dados no Firestore na `collection cafes` no formato: 
```
{
    'nome': 'The Coffee', 
    'imagem': 'https://thecoffee.s3-sa-east-1.amazonaws.com/images/the_coffee_berrini.jpeg',
    'position': location.data
}
```

`location.data` consiste nos dados de `geopoint` e `geohash` gerados pela biblioteca [geoflutterfire](https://pub.dev/packages/geoflutterfire#writing-geo-data).

## Packages e Links: 

- [Package geolocator](https://pub.dev/packages/geolocator)
- [Package google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
- [Package geoflutterfire](https://pub.dev/packages/geoflutterfire)
- [Ativar o SDK do Google Maps](https://console.cloud.google.com/apis/library)
- [Customizar o estilo do Mapa](https://mapstyle.withgoogle.com/)
- [Galeria de estilos de Mapa](https://snazzymaps.com/)
