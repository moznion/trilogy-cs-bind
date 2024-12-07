# frozen_string_literal: true

require "trilogy"
require "stringio"

class Trilogy
  module CS
    module Bind
      class Error < StandardError; end
    end
  end

  # xquery executes the query with client-side placeholder binding.
  # This method raises an error if the number of placeholders in the query does not match the number of values provided for binding.
  #
  # @rbs sql: String -- SQL query to execute might have placeholders (i.e. 0 or more '?' terms)
  # @rbs *values: untyped -- Values to bind into the SQL query.
  # @rbs flags: Integer | nil
  # @rbs return: Trilogy::Result
  def xquery(sql, *values, flags: nil)
    sql = values.empty? ? sql : pseudo_bind(sql, values)
    return query_with_flags(sql, flags) if flags

    query(sql)
  end

  # pseudo_bind binds the values with escaping into the given SQL query.
  #
  # @rbs sql: String -- An SQL query to execute might have placeholders (i.e. 0 or more '?' terms)
  # @rbs values: Array[untyped] -- Values to bind into the SQL query.
  # @rbs return: String -- An SQL query that is bound to values with escaping.
  def pseudo_bind(sql, values)
    escaped = StringIO.new

    values_num = values.length
    placeholder_count = 0

    sql.each_char do |c|
      unless c == "?"
        escaped << c
        next
      end

      placeholder_count += 1
      value = values[placeholder_count - 1]
      escaped << (value.is_a?(Array) ? value.map { |v| _escape(v) }.join(",") : _escape(value))
    end

    if values_num != placeholder_count
      raise CS::Bind::Error, "the number of placeholders in the query does not match the number of values provided for binding"
    end

    escaped.string
  end

  private

  # @rbs raw: untyped
  # @rbs return: String
  def _escape(raw)
    case raw
    when nil
      "NULL"
    when true
      "TRUE"
    when false
      "FALSE"
    else
      if raw.respond_to?(:strftime)
        "'#{raw.strftime("%Y-%m-%d %H:%M:%S")}'"
      else
        "'#{escape(raw.to_s)}'"
      end
    end
  end
end
