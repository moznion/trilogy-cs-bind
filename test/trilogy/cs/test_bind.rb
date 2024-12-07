# frozen_string_literal: true

require "test_helper"
require "time"
require "lib/trilogy/cs/bind"

class Trilogy
  module Cs
    class TestBind < Minitest::Spec
      before(:all) do
        @client = Trilogy.new(host: "127.0.0.1", port: 33_306, username: "root", password: "password", read_timeout: 2)
      end

      after(:all) do
        @client.close
      end

      describe "no placeholders" do
        it "should execute query successfully" do
          result = @client.xquery("select 1 AS ret").each_hash.to_a
          assert_equal result, [{"ret" => 1}]
        end

        it "should execute query successfully with flags" do
          result = @client.xquery("select 1 AS ret", flags: 1).each_hash.to_a
          assert_equal result, [{"ret" => 1}]
        end
      end

      describe "one placeholder" do
        it "should execute query successfully" do
          result = @client.xquery("select ? AS ret", "abc'def\"ghi\0jkl%mno").each_hash.to_a
          assert_equal result, [{"ret" => "abc'def\"ghi\0jkl%mno"}]
        end

        it "should execute query successfully with flags" do
          result = @client.xquery("select ? AS ret", "abc'def\"ghi\0jkl%mno", flags: 1).each_hash.to_a
          assert_equal result, [{"ret" => "abc'def\"ghi\0jkl%mno"}]
        end
      end

      describe "multiple placeholder" do
        it "should execute query successfully" do
          result = @client.xquery("select ? AS ret1, ? AS ret2, ? AS ret3", "'", '"', "\0").each_hash.to_a
          assert_equal result, [{
            "ret1" => "'",
            "ret2" => '"',
            "ret3" => "\0"
          }]
        end
      end

      describe "array placeholder" do
        it "should execute query successfully" do
          result = @client.xquery("select 1 AS ret where 1 IN (?)", [1, 2, 3]).each_hash.to_a
          assert_equal result, [{"ret" => 1}]
          result = @client.xquery("select 1 AS ret where 2 IN (?)", [1, 2, 3]).each_hash.to_a
          assert_equal result, [{"ret" => 1}]
          result = @client.xquery("select 1 AS ret where 3 IN (?)", [1, 2, 3]).each_hash.to_a
          assert_equal result, [{"ret" => 1}]
          result = @client.xquery("select 1 AS ret where 4 IN (?)", [1, 2, 3]).each_hash.to_a
          assert_equal result, []
        end
      end

      describe "special escapes" do
        it "should execute query with nil literal successfully" do
          result = @client.xquery("select 1 AS ret WHERE NULL IS ?", nil).each_hash.to_a
          assert_equal result, [{"ret" => 1}]
          result = @client.xquery("select 1 AS ret WHERE NULL IS NOT ?", nil).each_hash.to_a
          assert_equal result, []
        end

        it "should execute query with true literal successfully" do
          result = @client.xquery("select 1 AS ret WHERE TRUE = ?", true).each_hash.to_a
          assert_equal result, [{"ret" => 1}]
          result = @client.xquery("select 1 AS ret WHERE TRUE != ?", true).each_hash.to_a
          assert_equal result, []
        end

        it "should execute query with false literal successfully" do
          result = @client.xquery("select 1 AS ret WHERE FALSE = ?", false).each_hash.to_a
          assert_equal result, [{"ret" => 1}]
          result = @client.xquery("select 1 AS ret WHERE FALSE != ?", false).each_hash.to_a
          assert_equal result, []
        end

        it "should execute query with DateTime literal successfully" do
          result = @client.xquery("select 1 AS ret WHERE STR_TO_DATE('2024-12-07 12:34:56', '%Y-%m-%d %H:%i:%s') = ?",
            Time.strptime("2024-12-07 12:34:56", "%Y-%m-%d %H:%M:%S")).each_hash.to_a
          assert_equal result, [{"ret" => 1}]
          result = @client.xquery("select 1 AS ret WHERE STR_TO_DATE('2024-12-07 12:34:56', '%Y-%m-%d %H:%i:%s') = ?",
            Time.strptime("2006-01-02 15:04:05", "%Y-%m-%d %H:%M:%S")).each_hash.to_a
          assert_equal result, []
        end
      end

      describe "the number of values for binding is less than the number of placeholders" do
        it "should execute query successfully" do
          e = assert_raises Trilogy::CS::Bind::Error do
            @client.xquery("select ? AS ret1, ? AS ret2", 1)
          end

          assert_equal "the number of placeholders in the query does not match the number of values provided for binding", e.message
        end
      end

      describe "the number of placeholders is less than the number of values for binding" do
        it "should execute query successfully" do
          e = assert_raises Trilogy::CS::Bind::Error do
            @client.xquery("select ? AS ret", 1, 2)
          end

          assert_equal "the number of placeholders in the query does not match the number of values provided for binding", e.message
        end
      end
    end
  end
end
