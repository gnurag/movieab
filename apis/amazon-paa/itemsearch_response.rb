module AmazonPAA
  module Response
    
    class Argument
      include ROXML
      xml_name "Argument"
      xml_attribute :name, "Name"
      xml_attribute :value, "Value"
    end
    
    class OperationRequest
      include ROXML
      xml_name "OperationRequest"
      xml_text :request_id, "RequestId"
      xml_object :arguments, Argument, ROXML::TAG_ARRAY, "Arguments"
      xml_text :request_processing_time, "RequestProcessingTime"
    end

    class ItemSearchResponse
      include ROXML
      xml_name "ItemSearchResponse"
      xml_object :operation_request, OperationRequest
      xml_object :items, Items 
    end
  end
end
