// All content taken from http://taxii.mitre.org/specifications/version1.1/TAXII_Services_Specification.pdf


namespace java com.yellowcab
namespace py com.yellowcab

/**
* 4.1.4 Timestamp Labels
 Timestamp Labels give a relative ordering to the content within a TAXII Data Feed. Timestamp Labels are
  used to provide an index into a TAXII Data Feed, making it possible to request content from a TAXII Data
  Feed that comes “before” and/or “after” a particular Timestamp Label.
  Each piece of content within a TAXII Data Feed is assigned a Timestamp Label. Multiple pieces of content
  MUST NOT be assigned the same Timestamp Label unless they are added to the associated TAXII Data
  Feed as an "atomic" action. (This is necessary to prevent a race condition where a requester receives
  some of the content associated with a single Timestamp Label but not other content with that
  Timestamp Label because the request arrived part-way through the addition of this set of content.)
  While a Timestamp Label is in the form of a timestamp, it is important to note that Timestamp Labels do
  not necessarily correspond to any chronological event nor do they necessarily align with timestamps
  that appear within the content of a TAXII Data Feed. The Timestamp Label is just a label, rather than a
  reference to some meaningful chronological time.
  Timestamp Labels MUST conform to a specific set of rules:
  1. Timestamp Labels MUST comply with the date-time construct as defined in IETF RFC 3339 [4].
  2. Each piece of content in a TAXII Data Feed MUST have a Timestamp Label.
  3. When a new piece of content (or set of content) is added to a TAXII Data Feed, that content
  MUST be assigned a Timestamp Label later than the Timestamp Label of any other piece of
  content within that feed. Note that this property MUST be maintained even if the Producer
  assigns Timestamp Labels that use different time zones: new Timestamp Labels MUST be
  chronologically later than all other previous Timestamp Labels within that TAXII Data Feed. (In
  other words, one can use Timestamp Labels to create an unambiguous ordering of content
  within a TAXII Data Feed.)
  4. A Timestamp Label MAY have between 0 and 6 decimal places in its fractional second. A
  Timestamp Label MUST NOT contain more than 6 decimal places in its fractional second. While
  TAXII currently prohibits more than 6 decimal places of fractional second precision within
  Timestamp Labels, back-end processing SHOULD NOT rely on this since this requirement may be
  removed in future releases of TAXII.

NOTE:  String was chosen, because it exists in all languages, and creating some complex time logic is not in anyones best interest
**/
typedef string TimestampLabel

/**
* Specifies ids and subtypes for content bindings
**/
struct ContentBinding{
    1: required string contentBindingId;
    /**
    * This field identifies content binding subtypes of the specified
      Content Binding. Each Subtype MUST be a Content Binding
      Subtype ID as defined in the TAXII Content Binding
      Reference or by a third party. Absence indicates that all
      subtypes of the specified Content Binding are accepted
    **/
    2: optional set<string> subType;
}

/**
* A TAXII Content Block contains a piece of content consisting of structured cyber threat information.
**/
struct ContentBlock{
    1: required ContentBinding contentBinding;
    /**This field contains a piece of content of the type specified
       by the Content Binding.
    */
    2: required string content;
    /** This field contains a Timestamp Label associated with this
        Content Block. This field is only relevant if the content
        came from a TAXII Data Feed. It is at the sender's
        discretion as to whether this is included.
    */
    3: optional TimestampLabel timestampLabel;
    /** This field contains prose information for the message
        recipient. This message is not required to be machine
        readable and is usually a message for a human operator.
    */
    4: optional string message;
    /**This field contains an arbitrary amount of padding for this
       Content Block. This is typically used to obfuscate the size
       of the Content Block when the Content is encrypted. This
       field MUST be ignored when processing a Content Block.
    */
    5: optional string padding;
    /**This field contains a signature associated with this Content
       Block. The scope of this field is limited to the Content Block
       that contains this field.
    */
    6: optional string signature;
}


/**
* Represents the TAXII specific message body types.
**/
enum MessageBodyType{

    /**
      This message is sent to a Collection Management Service to request information about the available
      TAXII Data Collections. The body of this message is empty.
    **/
    COLLECTION_INFORMATION_REQUEST,
    /**
      This message is sent in response to a TAXII Collection Information Request if the request is successful. If
      there is an error condition, a TAXII Status Message indicating the nature of the error is sent instead.
      Note that the Producer is under no obligation to list all Collections and can exclude any or all Collections
      from this response for any reason. For example, the Producer might wish to exclude Collections created
      for a specific customer from a list of all Collections. As such, different requesters might be given
      different lists of Collections to their requests to the same Collection Management Service.
    **/
    COLLECTION_INFORMATION_RESPONSE,
   /**
     This message is sent to a Discovery Service to request information about provided TAXII Services. Such
     information includes what TAXII Services are offered, how the TAXII Daemons that support those
     Services can be accessed, and what protocols and message bindings are supported. The body of this
     message is empty.
    **/
   DISCOVERY_REQUEST,
   /**
     This message is sent from a Discovery Service in response to a TAXII Discovery Request if the request is
     successful. If there is an error condition, a TAXII Status Message indicating the nature of the error is sent
     instead.
    **/
   DISCOVERY_RESPONSE,
   /**
     A TAXII Inbox Message is used to push content from one entity to the TAXII Inbox Service of another
     entity.
    **/
   INBOX_MESSAGE,
   /**
     This message is used to establish a new subscription or manage an existing subscription. The Collection
     Management Service responds with a TAXII Manage Collection Subscription Response if the request is
     successful and will be honored or with a TAXII Status Message if the request is being rejected or there
     was an error.
    **/
   MANAGE_COLLECTION_SUBSCRIPTION_REQUEST,
   /**
     This message is returned in response to a TAXII Manage Collection Request Message if the requested
     action was successfully completed.
    **/
   MANAGE_COLLECTION_SUBSCRIPTION_RESPONSE,
   /**
     The TAXII Poll Fulfillment Request is used to collect results from a Poll Service where the result set has
     already been created. In general, this is used to collect results using Asynchronous Polling (see Section
     3.6.2) or to collect multiple parts of a large result set over a Multi-Part Poll Exchange (see Section 3.6.1).
    **/
   POLL_FULFILLMENT_REQUEST,
   /**
     This message is sent from a Consumer to a TAXII Poll Service to request that data from the TAXII Data
     Collection be returned to the Consumer. Poll Requests are always made against a specific TAXII Data
     Collection. Whether or not the Consumer needs an established subscription to that TAXII Data Collection
     in order to receive content is left to the Producer and can vary across Data Collections.
    **/
   POLL_REQUEST,
   /**
     This message is sent from a Consumer to a TAXII Poll Service to request that data from the TAXII Data
     Collection be returned to the Consumer. Poll Requests are always made against a specific TAXII Data
     Collection. Whether or not the Consumer needs an established subscription to that TAXII Data Collection
     in order to receive content is left to the Producer and can vary across Data Collections.
    **/
   POLL_RESPONSE,
   /**
     A TAXII Status Message is used to indicate a condition of success or error. Status Messages are always
     sent from a TAXII Daemon to a TAXII Client in response to a TAXII Message. A TAXII Status Message can
     be used to indicate that an error occurred when processing a received TAXII Message. Error conditions
     can occur because the request itself was invalid or because the recipient was unwilling or unable to
     honor the request. The Status Message is also used in the Inbox Exchange (see Section 3.2) to indicate
     successful reception of an Inbox Message or for Asynchronous Polling (see Section 3.6.2) to indicate a
     Poll Request will be fulfilled at a later time.
   **/
   STATUS

}


/**
* Represents the header of a standard TAXII message
**/
struct TAXIIHeader{
    1: required string messageId;
    /**
    * The type of the TAXII Message. Only identifiers for defined
      TAXII Messages, as defined in Section 4.4, are allowed in this
      field. (I.e., third parties MUST NOT define their own TAXII
      Message Body Types.)
    **/
    2: required MessageBodyType messageBodyType;
    /**
    * Contains the Message ID of the message to which this is a
      response, if this message is a response.
    **/
    3: optional string inResponseTo;
    /**
    * Third parties MAY define their own additional header fields.
      Extended-Header fields that are not recognized by a recipient
      SHOULD be ignored. Requirements for Extended-Header fields
      are listed in Section 4.1.5
    **/
    4: optional list<string> extendedHeaders;
    /**
     This field contains a cryptographic signature for this TAXII
      Message. The scope of this signature is the entire TAXII
      Message (i.e., Signatures contained in this field can sign all or
      any parts of the TAXII Message). Details for how a signature is
      expressed are covered in each TAXII Message Binding
      Specification.
    **/
    5: optional string signature;
}


/**
* Represents a message that is TAXII compliant.
**/
struct Message{
    1: required string id;
    2: required string inResponseTo;
}


struct InboxServiceContent{
/**
* This field identifies content binding subtypes of the specified
  Content Binding. Each Subtype MUST be a Content Binding
  Subtype ID as defined in the TAXII Content Binding
  Reference or by a third party. Absence of this field indicates
  that the Inbox Service accepts all subtypes of the specified
  Content Binding.

**/
    1: required list<string> subtypes;
}



/**
* A TAXII query
**/
struct Query{
/**
* This field contains the Query Format ID that identifies the
  format of the Supported Query.

**/
    1: required string formatId;
    2: required string expression;
}


/**
* Represents known service types
**/
enum ServiceType{
    COLLECTION_MANAGEMENT
    DISCOVERY,
    INBOX,
    POLL
}

/**
* Represents a service as defined by the TAXII specification.
**/
struct ServiceInstance{
/**
* This field MAY appear any number of times (including 0),
  each time identifying a different instance of a TAXII Service.
  This field has several sub-fields. Absence of this field
  indicates that there are no TAXII Services that can be
  revealed to the requester
**/
    1: required ServiceType serviceType;
    /**
    * This field identifies the TAXII Services Specification to which
      this Service conforms. This MUST be a TAXII Services Version
      ID as defined in a TAXII Services Specification.
    **/
    2: required string serviceVersion;
    /**
    * This field identifies the protocol binding supported by this
      Service. This MUST be a TAXII Protocol Binding Version ID as
      defined in a TAXII Protocol Binding Specification or by a third
      party
**/
    3: required string protocolBinding;
    /**
    * This field identifies the network address that can be used to
      contact TAXII Daemon that hosts this Service. The Service
      Address MUST use a format appropriate to the Protocol
      Binding field value.
    **/
    4: required string serviceAddress;
    /**
    * This field identifies the message bindings supported by this
      Service instance. Each message binding MUST be a TAXII
      Message Binding Version ID as defined in a TAXII Message
      Binding Specification or by a third party.
**/
    5: required list<string> messageBindings;
    /**
    * This field indicates that the service supports a particular
      format of Query expression. This field SHOULD NOT be
      present for any Service Type other than Collection
      Management Service or Poll Service; recipients MUST ignore
      this field for other Service Types. The Query Format subfield
      identifies the type of query format supported. Other
      subfields MAY also be present and provide additional
      support information about the indicated query format -
      these parameters are identified in the definition of the given
      query format. (See Section 5.5 for more on Query Format
      definition.) Multiple instances of this field may appear, but
      each instance MUST include a different Query Format value.
      Absence of this field indicates that the identified service
      does not support the use of Query expressions
**/
    6: optional list<Query> supportedQueries;
    /**
    * This field SHOULD NOT be present for any Service Type other
      than Inbox; recipients MUST ignore this field if the Service
      Type is not Inbox. This field identifies content bindings that
      this Inbox Service is willing to accept. Each Inbox Service
      Accepted Content MUST be a Content Binding ID as defined
      in the TAXII Content Binding Reference or by a third party.
      Absence of this field when the Service Type field indicates an
      Inbox Service means that the Inbox Service accepts all
      content bindings.

**/
    7: optional list<InboxServiceContent> inboxServiceAcceptedContents;
    /**
    * This field indicates whether the identity of the requester
      (authenticated or otherwise) is allowed to access this TAXII
      Service. This field can indicate that the requester is known to
      have access, known not to have access, or that access is
      unknown. Absence of this field indicates that access is
      unknown.

**/
    8: optional bool isAvailable;
    /**
    * This field contains a message regarding this Service instance.
      This message is not required to be machine readable and is
      usually a message for a human operator.

**/
    9: optional Message message;
}







/**
* Response detail types for MessageStatusType
**/
struct MessageStatusDetail{
    1: required string key;
    2: required string value;
}

/**
* All binding information taken from: http://taxii.mitre.org/specifications/version1.1/TAXII_Services_Specification.pdf
**/
enum MessageStatusType{

    /**
    This is used to indicate that a Producer encountered an unexpected error
    when creating a result set under Asynchronous Polling. (See Section 3.6.2.)
    As a result, the result set in question is not going to be available to the
    Consumer.
     */
    ASYNCHRONOUS_POLL_ERROR,
    /**
    The message sent could not be interpreted by the TAXII Daemon (e.g., it
    was malformed and could not be parsed).
     */
    BAD_MESSAGE,
    /**
      This is used in cases where the TAXII Client's action is being denied for
      reasons other than a failure to provide appropriate authentication
      credentials. For example, a Collection Management Service might limit the
      number of subscriptions a given Consumer is allowed to create. In this case,
      if a Consumer attempts to create a too many subscriptions, a TAXII
      Daemon might send a Status Message of type "Denied".
     */
    DENIED,
    /**
    This is used to indicate a problem with the use of the Destination Collection
    Name field in an Inbox Message. It can indicate either that:
     The recipient of an Inbox Message requires that the sender indicate
    a Destination Collection Name, but the Inbox Message did not do
    so.
     The recipient of an Inbox Message prohibits the sender from
    dictating a Destination Collection Name, but the Inbox Message
    had one or more Destination Collection Name fields.
    See Section 3.2.1 for more on pushing content to Data Collections.

     */
    DESTINATION_COLLECTION_ERROR,
    /**
    A general indication of failure. This might indicate some problem that does
    not have a defined Status Type, but MAY also be sent in place of any other
    TAXII Status Messages if a TAXII Daemon does not wish to disclose details
    for the failure of a request.

     */
    FAILURE,
    /**
    This Status Type is sent in response to a Poll Fulfillment Request that
    requests a particular Result Part Number but the result has fewer than that
    number of parts.
     */
    INVALID_RESPONSE_PART,
    /**
    This Status Type is sent in response to a Poll Fulfillment Request that
    requests a particular Result Part Number but the result has fewer than that
    number of parts.
     */
    NETWORK_ERROR,
    /**
    The request named a target (e.g., a TAXII Data Collection name) that does
    not exist on the TAXII Daemon.

     */
    NOT_FOUND,
    /**
    This is sent in response to a Poll Request to indicate that the requested
    results will be provided at a later time (rather than in a direct Poll
    Response). It is primarily used in cases where the Poll Request takes more
    time to process than allowed by the underlying protocol but the Producer
    still intends to create a result set and make it available.

     */
    PENDING,
    /**
    The requester attempted to create a subscription where the requester only
    polls for content, but the associated TAXII Data Collection is not available to
    the requester via polling.
     */
    POLLING_NOT_SUPPORTED,
    /**
    The request cannot be performed at the current time but may be possible
    in the future. The requested action will not occur until and unless the
    request is repeated.

     */
    RETRY,
    /**
    The message sent was interpreted by the TAXII Daemon and the requested
    action was completed successfully. Note that some request messages have
    a corresponding response message used to indicate successful completion
    of a request. In these cases, that response message MUST be used instead
    of sending a Status Message of type "Success".
     */
        SUCCESS,
    /**
    The requested activity requires authentication, but either the TAXII Client
    did not provide authentication or their authenticated identity did not have
    appropriate access rights. (Note that any authentication credentials are
    provided at the protocol level rather than as part of a TAXII Message.)

     */
    UNAUTHORIZED,
        /**
        The requester identified a set of content bindings to be used in the
        fulfillment of its request, but none of those content bindings are supported
        for the requested action.

         */
        UNSUPPORTED_CONTENT_BINDING,
    /**
    The requester identified a set of message bindings to be used in the
    fulfillment of its request, but none of those message bindings are
    supported for the requested action.

     */
    UNSUPPORTED_MESSAGE_BINDING,

    /**
    The requester identified a set of protocol bindings to be used in the
    fulfillment of its request, but none of
     */
    UNSUPPORTED_PROTOCOL_BINDING,
    /**
    The requester included a Query expression, but the format of the Query
    Expression was not supported (or the receiving Service does not support
    Query.)

     */
    UNSUPPORTED_QUERY_FORMAT
}

/**
* Represents the status of a message.
**/
struct MessageStatus{
    1: required MessageStatusType status;
    /**
     Additional information for the status. There is no expectation
     that this field be interpretable by a machine; it is instead
     targeted to a human operator.
    **/
    2: optional string description;
    3: required Message message;
    /**
      Additional information for the status. There is no expectation
      that this field be interpretable by a machine; it is instead
      targeted to a human operator.
    **/
    4: required list<MessageStatusDetail> statusDetails;
}

struct StatusMessage{
/**
* If present, indicates the Result Part that is being collected.
  see: MessageStatusType
**/
    1: required string statusType;
    /**
    * A field for additional information about this status in a
      machine-readable format. Contents of the Status Detail field
      consist of zero or more name-value pairs. (The details of how
      these name-value pairs are structured in a particular message
      binding are provided in the appropriate TAXII Message Binding
      Specification.) The individual Status Types indicate the
      standard names and appropriate values for this these sun-
      fields (if any). Values may consist of structured content. Third
      parties MAY define their own Status Detail sub-fields.
      Internal key value pair struct is being used here.
    **/
    2: optional MessageStatusType statusDetail;
    /**
    * Additional information for the status. There is no expectation
      that this field be interpretable by a machine; it is instead
      targeted to a human operator.

    **/
    3: optional string message;
}


/**
* A wrapper for TAXII compliant requests
**/
struct TAXIIRequest{
    1: required MessageBodyType messageType;
}

/**
* A wrapper for TAXII compliant requests
**/
struct TAXIIResponse{
    1: required MessageStatusType status;
}

/**
* This message is sent to a Discovery Service to request information about provided TAXII Services. Such
  information includes what TAXII Services are offered, how the TAXII Daemons that support those
  Services can be accessed, and what protocols and message bindings are supported. The body of this
  message is empty.

**/
struct DiscoveryRequest{
    1: required MessageBodyType messageType = MessageBodyType.DISCOVERY_REQUEST;
}


/**
  If the Discovery Daemon detects an error that prevents processing of the message then it MUST respond with an
  appropriate Status Message indicating that the exchange failed. Otherwise, the Discovery Daemon
  passes the relevant information to its TAXII Back-end. The TAXII Back-end uses this information, along
  with its own access control policy, to create a list of TAXII Services to be returned or determine that the
  request will not be fulfilled. (E.g., the request might be denied due to a lack of authorization on the part
  of the requester.) If the request is honored, a list of TAXII Services is packaged into a Discovery Response
  which is sent back to the TAXII Client. (Not that this list might be 0-length if there are no services the
  requester is permitted to see.) The TAXII Client receives this message and passes the information to its
  own TAXII Back-end for processing. If the Discovery Daemon does not respond with a Discovery
  Response for any reason, the Discovery Daemon MUST respond with a Status Message indicating the
  reason that prevented it from returning a successful response. A TAXII Status Message MUST only be
  returned to indicate an error occurred or that the request was denied
**/
struct DiscoveryResponse{
    1: required TAXIIHeader header;
    2: optional MessageStatusType status;
    3: optional list<ServiceInstance> allowedServices;
}


/**
* This message is sent from a Discovery Service in response to a TAXII Discovery Request if the request is
  successful. If there is an error condition, a TAXII Status Message indicating the nature of the error is sent
  instead.

**/
struct DiscoveryResponseMessage{
/**
* This field MAY appear any number of times (including 0),
  each time identifying a different instance of a TAXII Service.
  This field has several sub-fields. Absence of this field
  indicates that there are no TAXII Services that can be
  revealed to the requester.

**/
    1: optional list<ServiceInstance> serviceInstances;

}

/**
 * Responsible for TAXII discovery specification as detailed in section 2.1.1 of
 * http://taxii.mitre.org/specifications/version1.1/TAXII_Services_Specification.pdf
**/
service DiscoveryService{
    set<ServiceInstance> knownServices(),
    DiscoveryResponse makeRequest(1: DiscoveryRequest request);
}

enum CollectionType{
    /** ordered Collection */
    DATA_FEED,
    /** unordered Collection */
    DATA_SET
}



struct SupportedContent{
/**
* This field identifies content binding subtypes of the
  specified Supported Content binding. Each Subtype
  MUST be a Content Binding Subtype ID as defined in
  the TAXII Content Binding Reference or by a third
  party. Absence of this field indicates that this Data
  Collection supports all subtypes of the specified
  Supported Content binding.

**/
    1: optional set<string> subtypes;
}

/**
* Represents the way that messages are sent out.
**/
struct PushMethod{
/**
* This field identifies a protocol binding that can be
  used by the Producer to push content from this Data
  Collection to a Consumer's Inbox Service instance.
  This MUST be a TAXII Protocol Binding Version ID as
  defined in a TAXII Protocol Binding Specification or by
  a third party.
**/
    1: required string pushProtocol;
    /**
    * This field identifies the message bindings that can be
      used by the Producer to push content from this Data
      Collection to an Inbox Service instance using the
      protocol identified in the Push Protocol field. Each
      message binding MUST be a TAXII Message Binding
      Version ID as defined in a TAXII Message Binding
      Specification or by a third party.
**/
    2: required set<string> pushMessageBindings;
}

/**
* Represents a polling instance.
**/
struct PollingInstance{
    /**
    * This field identifies the protocol binding supported by
      this Poll Service instance. This MUST be a TAXII
      Protocol Binding Version ID as defined in a TAXII
      Protocol Binding Specification or by a third party.
    **/
    1: required string pollProtocol;
    /**
    * This field identifies the address that can be used to
      contact the TAXII Daemon hosting this Poll Service
      instance. This field MUST use a format appropriate to
      the Poll Protocol field value.
    **/
    2: required string pollAddress;
    /**
    * This field identifies the message bindings supported
      by this Poll Service instance. Each message binding
      MUST be a TAXII Message Binding Version ID as
      defined in a TAXII Message Binding Specification or by
      a third party.
    **/
    3: required set<string> pollMessageBindings;
}

/**
* Represents a subscription.
**/
struct SubscriptionMethod{
/**This field identifies the protocol binding supported by
   this Collection Management Service instance. This
   MUST be a TAXII Protocol Binding Version ID as
   defined in a TAXII Protocol Binding Specification or by
   a third party */
    1: required string subscriptionProtocol;
    /**
    * This field identifies the address that can be used to
      contact the TAXII Daemon hosting this Collection
      Management Service instance. This field MUST use a
      format appropriate to the Subscription Protocol field
      value.
    **/
    2: required string subscriptionAddress;
    /**
    * This field identifies the message bindings supported
      by this Collection Management Service Instance. Each
      message binding MUST be a TAXII Message Binding
      Version ID as defined in a TAXII Message Binding
      Specification or by a third party.

    **/
    3: required set<string> subscriptionMessageBindings;
}

/**
* Represents a receiving inbox service.
**/
struct ReceivingInboxService{
    /**
    * This field identifies the protocol binding supported by
      this Inbox Service instance. This MUST be a TAXII
      Protocol Binding Version ID as defined in a TAXII
      Protocol Binding Specification or by a third party.

    **/
    1: required string inboxProtocol;
    /**
    * This field identifies the address that can be used to
      contact the TAXII Daemon hosting this Inbox Service
      instance. This field MUST use a format appropriate to
      the Inbox Protocol field value.
    **/
    2: required string inboxAddress;
    /**
    * This field identifies the message bindings supported
      by this Inbox Service instance. Each message binding
      MUST be a TAXII Message Binding Version ID as
      defined in a TAXII Message Binding Specification or by
      a third party
    **/
    3: required set<string> inboxMessageBindings;
    /**
    * This field contains Content Binding IDs indicating that
      the indicated Inbox Service only accepts content
      using specific content bindings. Each Supported
      Content value MUST be a Content Binding ID as
      defined in the TAXII Content Binding Reference or by
      a third party. Absence of this field indicates that the
      Inbox Service supports all content bindings supported
      by the Data Collection.
    **/
    4: optional set<SupportedContent> supportContent;
}

/**
* A TAXII Data Collection.
**/
struct CollectionInformation{
    /**
    * This field contains the name by which this TAXII Data
      Collection is identified.
    **/
    1: required string name;
    /**
    * This field indicates whether this Data Collection is a
      Data Feed (ordered Collection) or a Data Set
      (unordered Collection). Absence of this field denotes
      that this Collection is a Data Feed
    **/
    2: optional CollectionType type = CollectionType.DATA_FEED;
    /**
    * This field contains a prose description of this TAXII
      Data Collection. This field might also explain how to
      gain access to this TAXII Data Collection if out-of-band
      actions are required. (E.g., requires purchase of a
      contract, requires manual approval, etc.)
     **/
    3: required string description;
    /**
    * This field indicates the typical number of records
      added to this Data Collection daily. This represents a
      "typical" value and the producer is under no
      obligation to keep the Data Collection volume at the
      given level.
    **/
    4: optional i64 volume;
    /**
    * This field contains Content Binding IDs indicating
      which types of content might be found in this TAXII
      Data Collection. Each Supported Content value MUST
      be a Content Binding ID as defined in the TAXII
      Content Binding Reference or by a third party.
      Absence of this field indicates that this Data
      Collection supports all types of content.
    **/
    5: optional set<SupportedContent> supportedContent;
    /**
    * This field indicates whether the identity of the
      requester (authenticated or otherwise) is allowed to
      access this Collection. (Access could imply the ability
      to subscribe and/or the ability to send Poll Requests.)
      This field can indicate that the requester is known to
      have access, known not to have access, or that access
      is unknown. Absence of this field indicates that access
      is unknown.

      NOTE: For implementation purposes Unknown Access will be treated as equivalent to NO Access.
      There is no fundamental difference between these two choices, and regardless of the unknown/no access
      the client will not get a result.
    **/
    6: optional bool isAvailable = false;
    /**
    * This field identifies the protocols that can be used to
      push content from this Data Collection via a
      subscription and/or for pushed results of
      Asynchronous Polling. This field MAY appear multiple
      times if content from this TAXII Data Collection can be
      pushed via multiple protocols. This field has multiple
      sub-fields. Absence of this field indicates that
      content from this Data Collection cannot be pushed
      to a Consumer using TAXII.
    **/
    7: optional set<PushMethod> pushMethods;
    /**
    * This field identifies the bindings and address a
      Consumer can use to interact with a Poll Service
      instance that supports this TAXII Data Collection. This
      field MAY appear multiple times if multiple Poll
      Services support this TAXII Data Collection. This field
      has multiple sub-fields. Absence of this field indicates
      that this Data Collection cannot be polled using TAXII.

    **/
    8: optional set<PollingInstance> pollingServiceInstances;
    /**
    * This field identifies the protocol and address that can
      be used to contact the TAXII Daemon hosting the
      Collection Management Service that can process
      subscription requests for this TAXII Data Collection.
      Absence of this field indicates that there is not a TAXII
      Service that processes subscription requests for this
      Collection. In that case subscriptions, if supported,
      would need to be established by mechanisms other
      than TAXII. In the case of alternative subscription
      methods, the Collection Description field could
      provide procedures for subscribing.
**/
    9: optional set<SubscriptionMethod> subscriptionMethods;
    /**
    * This field identifies the bindings and address of an
      Inbox Service to which content can be pushed to have
      it added to the given Data Collection. This field MAY
      appear multiple times if multiple Inbox Services may
      receive content for this TAXII Data Collection. If this
      field is absent, the Consumer cannot use TAXII
      Messages to request that content to be added
      specifically to this Data Collection. Note that content
      sent to this Inbox Service MAY still be rejected by the
      recipient for any reason instead of adding it to the
      indicated Data Collection.

**/
    10: optional set<ReceivingInboxService> receivingInboxServices;
}


struct DataCollections{

    1: optional set<CollectionInformation> feedInformation;
}


/**
* This message is sent to a Collection Management Service to request information about the available
  TAXII Data Collections. The body of this message is empty.

**/
struct CollectionInformationRequest{
    1: required MessageBodyType messageType = MessageBodyType.COLLECTION_INFORMATION_REQUEST;
}

/**
* This message is sent in response to a TAXII Collection Information Request if the request is successful. If
  there is an error condition, a TAXII Status Message indicating the nature of the error is sent instead.
  Note that the Producer is under no obligation to list all Collections and can exclude any or all Collections
  from this response for any reason. For example, the Producer might wish to exclude Collections created
  for a specific customer from a list of all Collections. As such, different requesters might be given
  different lists of Collections to their requests to the same Collection Management Service.
**/
struct CollectionInformationResponse{
    1: required TAXIIHeader header;
    2: optional MessageStatusType status;
    3: optional list<CollectionInformation> collectionInformations;
}

/**
* The action to take for a collection subscription request
**/
enum CollectionSubscriptionAction{
/**
* Suspend delivery of content for the identified
  subscription
**/
   PAUSE,
   /**
   * Resume delivery of content for the identified
     subscription
**/
   RESUME,
   /**
   * Request information on subscriptions the
     requester has established for the named TAXII Data
     Collection. No subscription state is changed in response
     to this action.
**/
   STATUS,
   /**
   * Request a subscription to the named TAXII
     Data Collection.

**/
   SUBSCRIBE,
   /**
   * Request cancellation of an existing
     subscription to the named TAXII Data Collection.

**/
   UNSUBSCRIBE
}

/**
* Response type of this Subscription
**/
enum SubscriptionResponseType{
    /**
    * The requester is requesting that
      messages sent in fulfillment of this subscription only
      contain count information (i.e., content is not included).
    **/
    COUNT_ONLY,
    /**
    * Messages sent in fulfillment of this request are
      requested to contain full content
    **/
    FULL
}



struct SubscriptionParameter{
    /**
    * This field identifies the response type that is being
      requested as part of this subscription.
      Absence of this field indicates a request for FULL responses.

    **/
    1: optional SubscriptionResponseType responseType = SubscriptionResponseType.FULL;
    /**
    * This field contains Content Binding IDs indicating which
      types of contents the Consumer requests to receive for this
      subscription. Multiple Content Binding IDs may be specified.
      This field MUST contain Content Binding IDs as defined in
      the TAXII Content Binding Reference or by a third party. If
      none of the listed Content Binding values are supported by
      the Data Collection, a Status Message with a status of
      'Unsupported Content Binding' SHOULD be returned.
      Absence of this field indicates that all content bindings are
      accepted.
    **/
    2: optional set<ContentBinding> contentBindings;
     /**
    * This field contains a query expression associated with this
      subscription request. If the subscription request is
      successful, only content that matches the query expression
      should be sent in fulfillment of the subscription. The query
      expression may be structured; the specific structure used for
      the query expression is identified in the Query Format field
     **/
     3: optional Query query;
}

/**
* Relates to content needed to fulfill a subscription
**/
struct DeliveryParameter{
    /**
    * This field identifies the protocol to be used when pushing
      TAXII Data Collection content to a Consumer's TAXII Inbox
      Service implementation. If the Data Collection does not
      support the named Inbox Protocol, a Status Message with a
      status of 'Unsupported Protocol Binding' SHOULD be
      returned. The Inbox Protocol MUST be a TAXII Protocol
      Binding Version ID as defined in a TAXII Protocol Binding
      Specification or by a third party.
    **/
    1: required string inboxProtocol;
    /**
    * This field identifies the address that can be used to contact
      the TAXII Daemon hosting the Inbox Service to which the
      Consumer requests content for this TAXII Data Collection to
      be delivered. The address MUST be of the appropriate type
      for the network protocol identified in the Inbox Protocol
      field.
    **/
    2: required string inboxAddress;
    /**
    * This field identifies the message binding to be used to send
      pushed content for this subscription. If the TAXII Data
      Collection does not support the Delivery Message Binding, a
      Status Message with a status of 'Unsupported Message
      Binding' SHOULD be returned. The Delivery Message Binding
      MUST be a TAXII Message Binding Version ID as defined in a
      TAXII Message Binding Specification or by a third party.
    **/
    3: required string deliveryMessageBinding;
}

/**
* This message is used to establish a new subscription or manage an existing subscription
**/
struct ManageCollectionSubscriptionRequest{
    /**
     This field identifies the name of the TAXII Data Collection to
    which the action applies.
    **/
    1: required string collectionName;
    /**
    * This field identifies the requested action to take
    **/
    2: required CollectionSubscriptionAction action;
    /**
    * This field contains the ID of a previously created
      subscription. For messages where the Action field is
      UNSUBSCRIBE, PAUSE, or RESUME, this field MUST be
      present. For messages where the Action field is SUBSCRIBE,
      this field MUST be ignored. For messages where the Action
      field is STATUS, this field MAY be present.
    **/
    3: optional string subscriptionId;
    /**
    * This field contains multiple subfields that indicate various
      aspects of the requested subscription. This field MUST be
      included if and only if the Action of this message is
      SUBSCRIBE and MUST be ignored for all other Action values.

      NOTE: Implementors must make this field required if and only if the
      value of the Action field is SUBSCRIBE
**/
    4: optional SubscriptionParameter subscriptionParameter;

    /**
    * This field identifies the parameters used to push content to
      the Consumer in fulfillment of a subscription. This field is
      only meaningful if the Action field is equal to SUBSCRIBE and
      is ignored for all other Action values. Absence of this field
      for a SUBSCRIBE action indicates that the requester is not
      requesting pushed content and will instead poll for
      subscription content use a Poll Service. In this case, if the
      TAXII Data Collection cannot be polled, a Status Message
      with a status of 'Polling Not Supported' SHOULD be
      returned.
    **/
    5: optional DeliveryParameter deliveryParameter;
}

/**
* Represents the different statuses of a Subscription
**/
enum SubscriptionStatus{
/**
* The subscription is established and active
**/
    ACTIVE,
    /**
    *  The subscription is established but
      currently in a paused state

**/
    PAUSED,
    /**
    * The subscription has been removed
      (would only appear in response to an UNSUBSCRIBE
      Action)

**/
    UNSUBSCRIBED
}

/**
* Represents an instance of a subscription
**/
struct SubscriptionInstance{
    1: required string subscriptionId;
    /**
    * This field contains the status of the Subscription.
If this field is absent, treat it as having a value of Active.

**/
    2: optional SubscriptionStatus status;
    /**
    * This field contains a copy of the Subscription
      Parameters of the Manage Collection Subscription
      Request message that established this subscription.
      This field MUST be present if this message is in
      response to a request with and Action field value of
      STATUS. This field MAY be present when responding to
      any other Action type.

**/
    3: optional SubscriptionParameter subscriptionParameter;
    /**
    * This field contains a copy of the Delivery Parameters (if
      present) of the Manage Collection Subscription Request
      Message that established this subscription. This field is
      present if and only if the Producer is willing and able to
      push content to the indicated Inbox Service in
      fulfillment of the established subscription. (It does not
      matter whether the subscription is currently in a
      PAUSED state.)

**/
    4: optional DeliveryParameter subscriptionDeliveryParameter;
    /**
    * Each Poll Instance represents an instance of a Poll
      Service that can be contacted to retrieve content
      associated with the named subscription. Its subfields
      indicate where Poll Request Messages can be sent for
      the given subscription. Multiple instances of this field
      may be present if there are multiple Poll Services that
      can be contacted for content for this subscription. If
      this field is absent, this indicates that polling for
      subscription content is not supported via TAXII.

**/
    5: optional set<PollingInstance> pollingInstances;
}
/**
* This message is returned in response to a TAXII Manage Collection Request Message if the requested
  action was successfully completed.
**/
struct ManageCollectionSubscriptionResponse{
    /**
    * This field identifies the name of the TAXII Data
      Collection to which the action applies.
    **/
    1: required string collectionName;
    /**
    * This field contains a message associated with the
      subscription response. This message is not required to
      be machine readable and is usually a message for a
      human operator.

    **/
    2: optional string message;
    /**
    * This field contains information about existing
      subscriptions by the requester to the given TAXII Data
      Collection. It appears any number of times (including 0)
      if this message is in response to a STATUS action, or
      exactly once if responding to any other action.

**/
    3: optional set<SubscriptionInstance> subscriptionInstances;
}

enum PollParameterResponseType{
    /** The requester is requesting that
        messages sent in fulfillment of this subscription only
        contain count information (i.e., content is not
        included).
    */
    COUNT_ONLY,
    /**Messages sent in fulfillment of this request are
       requested to contain full content.
    */
    FULL
}

/**
* Used to indicate the content of a Poll Response
**/
struct PollParameter{
    /** This field identifies the response type that is being
        requested. The Response Type MUST be one of the
        following:
         FULL – Messages sent in fulfillment of this request are
        requested to contain full content.
         COUNT ONLY – The requester is requesting that
        messages sent in fulfillment of this subscription only
        contain count information (i.e., content is not
        included).
        Absence of this field indicates a request for FULL
        responses
    */
    1: optional PollParameterResponseType responseType;
    /** This field contains Content Binding IDs indicating which
        types of contents the Consumer requests to receive.
        Multiple Content Binding IDs may be specified. This field
        MUST contain Content Binding IDs as defined in the TAXII
        Content Binding Reference or by a third party. If none of
        the listed Content Binding values are supported by the
        Data Collection, a Status Message with a status of
        'Unsupported Content Binding' SHOULD be returned.
        Absence of this field indicates that all content bindings are
        accepted.
    */
    2: optional set<ContentBinding> contentBinding;
    /**
    * This field contains a query expression. Only content that
      matches the query expression should be sent in response
      to this message. The query expression may be structured;
      the specific structure used for the query expression is
      identified in the Query Format field.

    **/
    3: optional Query query;
    /** This field indicates whether the Consumer is willing to
        support Asynchronous Polling. If this value is FALSE, the
        response MUST NOT respond with a Status Message with
        Status Type of "Pending". Absence of this field should be
        treated as indicating a value of FALSE. For more
        information on Asynchronous Polling, see Section 3.6.2.
    */
    4: optional bool allowAsynch = false;
    /**This field identifies how to push Asynchronous Poll Results
       to an Inbox Service specified by the poll requestor if the
       requestor wishes this to happen. This field MUST NOT be
       present if Allow Pending is absent or has a value of FALSE.
       If this field is absent but Allow Pending has a value of
       TRUE, this indicates that the Consumer will pull any
       Asynchronous Poll results rather than having them
       pushed. The Poll Service ignores this field if it is able to
       include results in a Poll Response Message. (Unsupported
       sub-field values should not lead to error Status Messages if
       the Delivery Parameters are ignored.) The Poll Service also
       ignores this field if it is not willing to push Asynchronous
       Poll Results to a Consumer
       */
    5: optional DeliveryParameter delieveryParameter;
}

/**
* This message is sent from a Consumer to a TAXII Poll Service to request that data from the TAXII Data
  Collection be returned to the Consumer. Poll Requests are always made against a specific TAXII Data
  Collection. Whether or not the Consumer needs an established subscription to that TAXII Data Collection
  in order to receive content is left to the Producer and can vary across Data Collections.

  NOTE:  Exactly one of Subscription ID or Poll Parameters MUST be  present
**/
struct PollRequest{
    /**
    * This field identifies the name of the TAXII Data Collection
      that is being polled.

    **/
    1: required string collectionName;
    /**
    * This field contains a Timestamp Label indicating the
      beginning of the range of TAXII Data Feed (i.e., ordered
      TAXII Data Collection) content the requester wishes to
      receive. The receiving TAXII Poll Service MUST ignore this
      field if the named TAXII Data Collection is a Data Set (i.e.,
      an unordered TAXII Data Collection). This field is exclusive
      (e.g., the requester is asking for content where the
      content's Timestamp Label is greater than this field value).
      Absence of this field when polling a Data Feed indicates
      that the requested range has no lower bound.

    **/
    2: optional TimestampLabel exclusiveBeginTimestampLabel;
    /**
    * This field contains a Timestamp Label indicating the end of
      the range of TAXII Data Feed content the requester wishes
      to receive. The receiving TAXII Poll Service MUST ignore
      this field if the named TAXII Data Collection is a Data Set.
      This range is inclusive (e.g., the requester is asking for
      content where the content's Timestamp Label is less than
      or equal to this field value). Absence of this field when
      polling a Data Feed indicates that the requested range has
      no upper bound.

    **/
    3: optional TimestampLabel inclusiveEndTimestampLabel;
    /**
    * This field identifies the existing subscription the Consumer
      wishes to poll. If the Poll Service requires established
      subscriptions for polling and this field is not present, the
      Poll Service SHOULD respond with a TAXII Status Message
      with a status of "Denied".

    **/
    4: optional string subscriptionId;
    /**
    * This field contains multiple subfields that indicate the
      content to return in the Poll Response. This field MUST
      NOT be present if a Subscription ID is provided; if a
      Subscription ID is provided, the corresponding information
      from the subscription is used instead.
    **/
    5: optional PollParameter pollParameter;
}

/**
* Provides information about record counts
**/
struct RecordCount{
    1: optional i64 count = 0;
    /**This field indicates whether the provided Record Count is
       the exact number of applicable records, or if the provided
       number is a lower bound and there may be more records
       than stated. The field contains a boolean value. A value of
       TRUE indicates that the actual number of matching records
       may be greater than the value that appears in the Record
       Count field. A value of FALSE indicates that the Record
       Count is an exact count of applicable records. If this field is
       absent, treat the field as having a value of FALSE.
*/
    2: optional bool partialCount = false;
}

/**
* This message is sent from a Poll Service in response to a TAXII Poll Request. Note that, as with any
  content provided by a Producer, the Producer MAY edit or eliminate content for any reason prior to
  providing it to a Consumer. As such, two Consumers polling the same Poll Service using identical
  parameters might receive different TAXII Data Collection content.
  If the named TAXII Data Collection is a TAXII Data Feed, the message indicates the time bounds within
  which TAXII Data Feed content was considered in the fulfillment of this request. As noted, content may
  be hidden from some Consumers, so the Poll Response Begin Timestamp and End Timestamp fields
  reflect the range of timestamps the Producer considers, but not all content in the considered range is
  necessarily included in the Poll Response Message. Nominally, the timestamp bounds in the Poll
  Response will be identical to the bounds provided in the Poll Request, with a "No Upper Bound" value
  This message is sent from a Poll Service in response to a TAXII Poll Request. Note that, as with any
  content provided by a Producer, the Producer MAY edit or eliminate content for any reason prior to
  providing it to a Consumer. As such, two Consumers polling the same Poll Service using identical
  parameters might receive different TAXII Data Collection content.
  If the named TAXII Data Collection is a TAXII Data Feed, the message indicates the time bounds within
  which TAXII Data Feed content was considered in the fulfillment of this request. As noted, content may
  be hidden from some Consumers, so the Poll Response Begin Timestamp and End Timestamp fields
  reflect the range of timestamps the Producer considers, but not all content in the considered range is
  necessarily included in the Poll Response Message. Nominally, the timestamp bounds in the Poll
  Response will be identical to the bounds provided in the Poll Request, with a "No Upper Bound" value

  Note:  At MOST one of exclusive begin timestamp or inclusive begin timestamp may appear
**/
struct TaxiiPollResponse{
    1: required string collectionName;
    2: optional string subscriptionId;
    3: optional TimestampLabel exclusiveBeginTimestampLabel;
    4: optional TimestampLabel inclusiveBeginTimestampLabel;
    /**This field contains a Timestamp Label indicating the end of
       the time range this Poll Response covers. This field is
       inclusive. This field MUST be present if the named Data
       Collection is a Data Feed. This field MUST NOT be present
       if the named Data Collection is a Data Set.
       NOTE: Required if for a Feed; prohibited otherwise
 */
    5: optional TimestampLabel inclusiveEndTimestampLabel;
    /**
    * This field contains a boolean value. If the field value is
      TRUE, this indicates there are additional parts remaining of
      a larger result set. If the field value is FALSE, this indicates
      that there are no parts of the result set with higher Result
      Part Numbers. If this field is absent, treat that as
      equivalent to a value of FALSE.

    **/
    6: optional bool more;
    /**
    * This field contains a Result ID that can be used in Poll
      Fulfillment Requests to identify other parts of this result
      set. This field MUST be present if the More field is set to
      TRUE.
**/
    7: optional string resultId;
    /**
    * This field contains an integer indicating the part of the
      result set contained in this Poll Response Message. Each
      part of a multi-part response is assigned a sequential
      integer starting with 1. (As such, the response to the initial
      Poll Request would have a 1 for this field.) If this field is
      absent, treat the field as having a value of 1.
    **/
    8: optional i32 resultPartNumber = 1;
    /**
    * Indicates the number of applicable records for the given
      Poll Request, which MUST be greater than or equal to the
      number of content records returned in this message's
      Content Block(s). This field SHOULD be present in all Poll
      Response messages.

    **/
    9: optional RecordCount recordCount;
    /**
    * This field contains additional information for the message
      recipient. There is no expectation that this field be
      interpretable by a machine; it is instead targeted to human
      readers.

    **/
    10: optional string message;
    /**
    * This field contains a piece of content and additional
      information related to the content. This field MAY appear
      0 or more times. See Section 0 for the definition of a
      Content Block.
    **/
    11: optional set<ContentBlock> contentBlock;
}

/**
* Used for details about a subscription
*
* NOTE:  In regards to Exclusive Begin and Inclusive Begin
* At most one of these fields may appear
* These fields serve the same purpose. Use of the Inclusive
  Begin Timestamp Label field is deprecated but retained for
  backwards compatibility with TAXII 1.0. Both fields MUST
  NOT appear together in the same message.

  Either field contains a Timestamp Label indicating the
  beginning of the time range this Inbox Message covers.
  (One field provides an exclusive value; the other provides
  an inclusive value.) Absence of either field indicates that
  the Inbox Message covers the earliest time for this TAXII
  Data Feed. The fields MUST NOT be included if the named
  TAXII Data Collection is a Data Set.
**/
struct InboxSubscriptionInformation{
    /**
    * This field indicates the name of the TAXII Data Collection
      from which this content is being provided.

    **/
    1: required string collectionName;
    /**
    * This field contains the Subscription ID for the subscription
      of which this content is being provided.

    **/
    2: required string subscriptionId;
    3: optional TimestampLabel exclusiveBeginTimestampLabel;
    4: optional TimestampLabel inclusiveBeginTimestampLabel;
    /**
    * This field contains a Timestamp Label indicating the end of
      the time range this Inbox Message covers. This field is
      inclusive. This field MUST be present if the named Data
      Collection is a Data Feed. This field MUST NOT be present
      if the named Data Collection is a Data Set.

    NOTE: Required if for a Feed; prohibited otherwise

    **/
    5: optional TimestampLabel inclusiveEndTimestampLabel;
}
/**
 A TAXII Inbox Message is used to push content from one entity to the TAXII Inbox Service of another
  entity.
**/
struct InboxMessage{
    /**
    * This field indicates the name of the TAXII Data Collection(s)
      to which this message’s content is being sent.
    **/
    1: optional set<string> destinationCollectionName;
    /**
    * This field contains prose information for the message
      recipient. This message is not required to be machine
      readable and is usually a message for a human operator.

    **/
    2: optional string message;
    /**
    * This field indicates the Result ID of the result set of which
      this message's content is a part. This is normally used
      when a Producer is pushing Asynchronous Poll results (see
      Section 3.6.2.2).

    **/
    3: optional string resultId;
    /**This field is only present if this message is being sent to
       provide content in fulfillment of an existing subscription.
       Absence of this field indicates that this message is not
       being sent in fulfillment of a subscription
       */
    4: optional InboxSubscriptionInformation subscriptionInformation;
    /**
    * Indicates the number of applicable records for the given
      response, which MUST be greater than or equal to the
      number of content records returned in this message's
      Content Block(s). This field SHOULD be present in all Poll
      Response messages.
    **/
    5: optional RecordCount recordCount;
    /**
    * This field contains a piece of content and additional
      information related to the content. This field MAY appear
      0 or more times. See Section 0 for the definition of a
      Content Block.

    **/
    6: optional list<ContentBlock> contentBlock;
}

/**
* The TAXII Poll Fulfillment Request is used to collect results from a Poll Service where the result set has
  already been created. In general, this is used to collect results using Asynchronous Polling (see Section
  3.6.2) or to collect multiple parts of a large result set over a Multi-Part Poll Exchange (see Section 3.6.1).

**/
struct PollFulfillmentRequest{
    /**
    * This field identifies the name of the TAXII Data Collection to
      which the request applies.

    **/
    1: required string collectionName;
    /**
    * The ID of the requested result set.

    **/
    2: required string resultId;
    /**
    * If present, indicates the Result Part that is being collected.

    **/
    3: required i32 resultPartNumber;
}