import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static const String _endpoint = 'http://localhost:3000/graphql';

  static GraphQLClient getClient() {
    final HttpLink httpLink = HttpLink(_endpoint);

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  static ValueNotifier<GraphQLClient> getClientNotifier() {
    return ValueNotifier<GraphQLClient>(getClient());
  }
}