/*
Copyright (c) 2017-2018 Guillaume Desquesnes, Valentin Lemière

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package tests;

import json2object.JsonParser;
import json2object.JsonWriter;
import json2object.utils.JsonSchemaWriter;
import utest.Assert;

class Parent {
	public var a : Int;
}

class Child extends Parent {
	public var b : String;
}

class OtherChild extends Parent {
	public var b : Bool;
}

class InheritanceTest {
	public function new () {}

	public function test1 () {
		var parser = new JsonParser<Parent>();
		var writer = new JsonWriter<Parent>();
		var data = parser.fromJson('{"a": 7}', "test.json");
		Assert.equals(0, parser.errors.length);
		Assert.equals(7, data.a);
		Assert.same(data, parser.fromJson(writer.write(data), "test"));
	}

	public function test2 () {
		var parser = new JsonParser<Child>();
		var writer = new JsonWriter<Child>();
		var data = parser.fromJson('{"a": 7, "b": "hello"}', "test.json");
		Assert.equals(0, parser.errors.length);
		Assert.equals(7, data.a);
		Assert.equals("hello", data.b);
		Assert.same(data, parser.fromJson(writer.write(data), "test"));
	}

	public function test3 () {
		var parser = new JsonParser<OtherChild>();
		var writer = new JsonWriter<OtherChild>();
		var data = parser.fromJson('{"a": 7, "b": true}', "test.json");
		Assert.equals(0, parser.errors.length);
		Assert.isTrue(data.b);
		Assert.same(data, parser.fromJson(writer.write(data), "test"));
	}

	public function test4 () {
		var parser = new JsonParser<Child>();
		var writer = new JsonWriter<Child>();
		var data = parser.fromJson('{"a": 7, "b": true}', "test.json");
		Assert.equals(2, parser.errors.length);
		Assert.same(data, parser.fromJson(writer.write(data), "test"));
	}

	public function test5 () {
		var parser = new JsonParser<OtherChild>();
		var writer = new JsonWriter<OtherChild>();
		var data = parser.fromJson('{"a": 7, "b": "hello"}', "test.json");
		Assert.equals(2, parser.errors.length);
		Assert.same(data, parser.fromJson(writer.write(data), "test"));
	}

	public function test6 () {
		var schema1 = new JsonSchemaWriter<Child>().schema;
		var schema2 = new JsonSchemaWriter<OtherChild>().schema;

		var oracle1 = '{"$$schema": "http://json-schema.org/draft-07/schema#","$$ref": "#/definitions/tests.Child","definitions": {"tests.Child": {"additionalProperties": false,"properties": {"a": {"type": "integer"},"b": {"type": "string"}},"required": ["a","b"],"type": "object"}}}';
		var oracle2 = '{"$$schema": "http://json-schema.org/draft-07/schema#","$$ref": "#/definitions/tests.OtherChild","definitions": {"tests.OtherChild": {"additionalProperties": false,"properties": {"a": {"type": "integer"},"b": {"type": "boolean"}},"required": ["a","b"],"type": "object"}}}';

		Assert.same(oracle1, schema1);
		Assert.same(oracle2, schema2);
	}
}
