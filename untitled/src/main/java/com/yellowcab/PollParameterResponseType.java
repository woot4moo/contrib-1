/**
 * Autogenerated by Thrift Compiler (0.9.1)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */
package com.yellowcab;


import java.util.Map;
import java.util.HashMap;
import org.apache.thrift.TEnum;

public enum PollParameterResponseType implements org.apache.thrift.TEnum {
  /**
   * The requester is requesting that
   * messages sent in fulfillment of this subscription only
   * contain count information (i.e., content is not
   * included).
   */
  COUNT_ONLY(0),
  /**
   * Messages sent in fulfillment of this request are
   * requested to contain full content.
   */
  FULL(1);

  private final int value;

  private PollParameterResponseType(int value) {
    this.value = value;
  }

  /**
   * Get the integer value of this enum value, as defined in the Thrift IDL.
   */
  public int getValue() {
    return value;
  }

  /**
   * Find a the enum type by its integer value, as defined in the Thrift IDL.
   * @return null if the value is not found.
   */
  public static PollParameterResponseType findByValue(int value) { 
    switch (value) {
      case 0:
        return COUNT_ONLY;
      case 1:
        return FULL;
      default:
        return null;
    }
  }
}
