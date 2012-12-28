### Generated by rprotoc. DO NOT EDIT!
### <proto file: sequence.proto>
# package fullcircle;
# 
# // used in both files and network
# 
# message BinarySequenceMetadata {
#   required uint32 frames_per_second = 1;
#   required uint32 width = 2;
#   required uint32 height = 3;
#   required string generator_name = 4;
#   required string generator_version = 5;
# }
# 
# message RGBValue {
#   required uint32 red = 1;
#   required uint32 green = 2;
#   required uint32 blue = 3;
#   required uint32 x = 4;
#   required uint32 y = 5;
# }
# 
# message BinaryFrame {
#   repeated RGBValue pixel = 1;
# }
# 
# message BinarySequence {
#   required BinarySequenceMetadata metadata = 1;
#   repeated BinaryFrame frame = 2;
# }
# 
# // network-only below. A Snip is a single network protocol message
# // containing some payload. The payload can include all protobuf types.
# message Snip {
# 
#   enum SnipType {
#     PING = 1;
#     PONG = 2;
#     ERROR = 3;
#     REQUEST = 4;
#     START = 5;
#     FRAME = 6;
#     ACK = 7;
#     NACK = 8;
#     TIMEOUT = 9;
#     ABORT = 10;
# 		EOS = 11;
#   }
#   required SnipType type = 1;
# 
#   message PingSnip {
#     required uint32 count = 1;
#   }
#   optional PingSnip ping_snip = 11;
# 
#   message PongSnip {
#     required uint32 count = 1;
#   }
#   optional PongSnip pong_snip = 12;
# 
#   enum ErrorCodeType {
#     OK = 1;
#     DECODING_ERROR = 2;
#     // To be extended.
#   }
#   message ErrorSnip {
#     required ErrorCodeType errorcode = 1;
#     required string description = 2;
#   }
#   optional ErrorSnip error_snip = 13;
# 
#   message RequestSnip {
#     required string color = 1;
#     required uint32 seqId = 2;
#     required BinarySequenceMetadata meta = 3;
#   }
#   optional RequestSnip req_snip = 14;
# 
#   message StartSnip {
#   }
#   optional StartSnip start_snip = 15;
# 
#   message FrameSnip {
#     required BinaryFrame frame = 1;
#   }
#   optional FrameSnip frame_snip = 16;
# 
#   message AckSnip {
#   }
#   optional AckSnip ack_snip = 17;
# 
#   message NackSnip {
#   }
#   optional NackSnip nack_snip = 18;
# 
#   message TimeoutSnip {
#   }
#   optional TimeoutSnip timeout_snip = 19;
# 
#   message AbortSnip {
#   }
#   optional AbortSnip abort_snip = 20;
# 
# 	message EosSnip {
# 	}
# 	optional EosSnip eos_snip = 21;
# }
# 
# 
# 

require 'protobuf/message/message'
require 'protobuf/message/enum'
require 'protobuf/message/service'
require 'protobuf/message/extend'

module Fullcircle
  class BinarySequenceMetadata < ::Protobuf::Message
    defined_in __FILE__
    required :uint32, :frames_per_second, 1
    required :uint32, :width, 2
    required :uint32, :height, 3
    required :string, :generator_name, 4
    required :string, :generator_version, 5
  end
  class RGBValue < ::Protobuf::Message
    defined_in __FILE__
    required :uint32, :red, 1
    required :uint32, :green, 2
    required :uint32, :blue, 3
    required :uint32, :x, 4
    required :uint32, :y, 5
  end
  class BinaryFrame < ::Protobuf::Message
    defined_in __FILE__
    repeated :RGBValue, :pixel, 1
  end
  class BinarySequence < ::Protobuf::Message
    defined_in __FILE__
    required :BinarySequenceMetadata, :metadata, 1
    repeated :BinaryFrame, :frame, 2
  end
  class Snip < ::Protobuf::Message
    defined_in __FILE__
    class SnipType < ::Protobuf::Enum
      defined_in __FILE__
      PING = value(:PING, 1)
      PONG = value(:PONG, 2)
      ERROR = value(:ERROR, 3)
      REQUEST = value(:REQUEST, 4)
      START = value(:START, 5)
      FRAME = value(:FRAME, 6)
      ACK = value(:ACK, 7)
      NACK = value(:NACK, 8)
      TIMEOUT = value(:TIMEOUT, 9)
      ABORT = value(:ABORT, 10)
      EOS = value(:EOS, 11)
    end
    required :SnipType, :type, 1
    class PingSnip < ::Protobuf::Message
      defined_in __FILE__
      required :uint32, :count, 1
    end
    optional :PingSnip, :ping_snip, 11
    class PongSnip < ::Protobuf::Message
      defined_in __FILE__
      required :uint32, :count, 1
    end
    optional :PongSnip, :pong_snip, 12
    class ErrorCodeType < ::Protobuf::Enum
      defined_in __FILE__
      OK = value(:OK, 1)
      DECODING_ERROR = value(:DECODING_ERROR, 2)
    end
    class ErrorSnip < ::Protobuf::Message
      defined_in __FILE__
      required :ErrorCodeType, :errorcode, 1
      required :string, :description, 2
    end
    optional :ErrorSnip, :error_snip, 13
    class RequestSnip < ::Protobuf::Message
      defined_in __FILE__
      required :string, :color, 1
      required :uint32, :seqId, 2
      required :BinarySequenceMetadata, :meta, 3
    end
    optional :RequestSnip, :req_snip, 14
    class StartSnip < ::Protobuf::Message
      defined_in __FILE__
    end
    optional :StartSnip, :start_snip, 15
    class FrameSnip < ::Protobuf::Message
      defined_in __FILE__
      required :BinaryFrame, :frame, 1
    end
    optional :FrameSnip, :frame_snip, 16
    class AckSnip < ::Protobuf::Message
      defined_in __FILE__
    end
    optional :AckSnip, :ack_snip, 17
    class NackSnip < ::Protobuf::Message
      defined_in __FILE__
    end
    optional :NackSnip, :nack_snip, 18
    class TimeoutSnip < ::Protobuf::Message
      defined_in __FILE__
    end
    optional :TimeoutSnip, :timeout_snip, 19
    class AbortSnip < ::Protobuf::Message
      defined_in __FILE__
    end
    optional :AbortSnip, :abort_snip, 20
    class EosSnip < ::Protobuf::Message
      defined_in __FILE__
    end
    optional :EosSnip, :eos_snip, 21
  end
end