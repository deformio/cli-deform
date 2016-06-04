import json

from flask import Flask, Response
from flask import request

app = Flask(__name__)



def get_project_info(identity, name):
    return {
        '_id': identity,
        'name': name,
        'settings': {
            'check_limits_period': '24h0m0s',
            'data_size_limit': 5242880,
            'delete_files': False,
            'files_size_limit': 10485760,
            'orphan_files_ttl': '168h0m0s',
            'rate_limit': 30
        },
        'status': {
            'data_size': 7584,
            'files_size': 0,
            'rate': 0
        }
    }


def json_response(data, status=200):
    return Response(
        json.dumps({
            'result': data
        }),
        content_type='application/json',
        status=status
    )


def get_auth_key():
    return request.headers.get('Authorization').split(' ')


def get_action():
    action = None
    method = request.method.lower()
    if method == 'post':
        action = request.headers.get('X-Action')
    return action


@app.route('/api/user/', methods=['POST'])
def user():
    action = get_action()
    if action == 'login':
        return json_response({
            'sessionId': '1234'
        })
    elif action is None:
        data = request.get_json()['payload']
        if data['email'] == 'mock@email.com':
            return json_response({
                'message': 'Check your email for confirmation code'
            })


@app.route('/api/user/projects/', methods=['POST', 'PUT'])
def projects():
    action = get_action()
    method = request.method.lower()
    if action is None:
        project = request.get_json().get('payload')
        if method == 'post':
            if project['_id'] == 'existing-project':
                return json_response(
                    {
                        'message': 'Project already exists'
                    },
                    409
                )
            else:
                return json_response(
                    get_project_info(
                        identity=project['_id'],
                        name=project['name']
                    ),
                    201
                )
        elif method == 'put':
            if project['_id'] == 'existing-project':
                status = 200
            else:
                status = 201
            return json_response(
                get_project_info(
                    identity=project['_id'],
                    name=project['name']
                ),
                status
            )
