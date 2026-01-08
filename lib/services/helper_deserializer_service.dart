import 'package:nexum_framework/exceptions/helper_deserialization_exception.dart';

import '../foundation/channel/friendly_buffer.dart';
import '../foundation/channel/helper_deserializer.dart';
import '../storages/helper_deserializer_registry.dart';

class HelperDeserializerService {
  static HelperDeserializerService get instance => _instance;
  static const HelperDeserializerService _instance = HelperDeserializerService._();

  const HelperDeserializerService._();

  T deserializeObject<T>(FriendlyBuffer friendlyBuffer) {
    final String identifier = friendlyBuffer.readString();
    final HelperDeserializer ? helperDeserializer = HelperDeserializerRegistry.instance.get(identifier);

    if(helperDeserializer == null) {
      throw HelperDeserializationException(
        "Não foi possivel encontrar o deserializador para o objeto: $identifier"
      );
    }


    final T packet = helperDeserializer.deserialize(friendlyBuffer);
    return packet;
  }
}