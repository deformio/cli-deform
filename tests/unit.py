# -*- coding: utf-8 -*-
import unittest
import json
import shutil
import tempfile
import os

from hamcrest import assert_that, equal_to, instance_of

from src.utils import parse_json_with_files


class TestUtils__parse_json_with_files(unittest.TestCase):
    def setUp(self):
        self.file_path = os.path.join(tempfile.gettempdir(), 'file.txt')
        self.file_content = 'some content'
        with open(self.file_path, 'w') as ff:
            ff.write(self.file_content)

    def check_file(self, obj):
        assert_that(obj.name, equal_to(self.file_path))

    def test_should_parse_simple_json(self):
        data = {
            'hello': {
                'world': [1, 2, 3]
            }
        }
        assert_that(
            parse_json_with_files(json.dumps(data)),
            equal_to(data)
        )

    def test_file_in_simple_string(self):
        data = '@"%s"' % self.file_path
        response = parse_json_with_files(data)
        assert_that(response, instance_of(file))
        self.check_file(response)

    def test_file_in_list(self):
        data = """[
           @"%s",
            1,
            "hello"
        ]""" % self.file_path
        response = parse_json_with_files(data)
        assert_that(response[0], instance_of(file))
        self.check_file(response[0])

        assert_that(response[1], equal_to(1))
        assert_that(response[2], equal_to('hello'))

    def test_file_in_dict_in_list(self):
        data = """{
           "info": {
               "files": [
                   "@/this/is/not/file",
                   "/this/is/not-file/too/@",
                   @"%s"
               ]
           }
        }""" % self.file_path
        response = parse_json_with_files(data)
        assert_that(
            response['info']['files'][0],
            equal_to('@/this/is/not/file')
        )
        assert_that(
            response['info']['files'][1],
            equal_to('/this/is/not-file/too/@')
        )
        assert_that(
            response['info']['files'][2],
            instance_of(file)
        )
        self.check_file(response['info']['files'][2])

    def test_many_files(self):
        self.second_file_path = os.path.join(tempfile.gettempdir(), 'file.txt')
        with open(self.second_file_path, 'w') as ff:
            ff.write('second file content')

        data = """[
            @"%s",
            100,
            @"%s"
        ]""" % (
            self.file_path,
            self.second_file_path
        )
        response = parse_json_with_files(data)
        assert_that(response[0], instance_of(file))
        assert_that(response[0].name, equal_to(self.file_path))
        assert_that(response[1], equal_to(100))
        assert_that(response[2], instance_of(file))
        assert_that(response[2].name, equal_to(self.second_file_path))


if __name__ == '__main__':
    unittest.main()
