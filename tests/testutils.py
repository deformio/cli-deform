import os, json
from pydeform import Client


def get_setting(name, required=True):
    if name in os.environ:
        try:
            return json.loads(str(os.environ[name]))
        except ValueError:
            raise ValueError(
                "%s should be set in JSON format. Given %s" % (
                    name,
                    os.environ[name]
                )
            )
    else:
        if required:
            raise ValueError(
                'You should provide "%s" environ for settings' % name.upper()
            )


def _get_free_port():
    import socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('127.0.0.1', 0))
    s.listen(1)
    port = s.getsockname()[1]
    s.close()
    return port


CONFIG = {
    'DEFORM': {
        'HOST': get_setting('DEFORM_HOST'),
        'PORT': get_setting('DEFORM_PORT', required=False),
        'REQUEST_DEFAULTS': get_setting('DEFORM_REQUEST_DEFAULTS', required=False),
        'API_BASE_PATH': get_setting(
            'DEFORM_API_BASE_PATH',
            required=False
        ) or '/api/',
        'SECURE': get_setting('DEFORM_SECURE'),
        'PROJECT': get_setting('DEFORM_PROJECT'),
        'PROJECT_NAME': get_setting('DEFORM_PROJECT_NAME'),
        'PROJECT_TOKEN': get_setting('DEFORM_PROJECT_TOKEN'),
        'EMAIL': get_setting('DEFORM_EMAIL'),
        'PASSWORD': get_setting('DEFORM_PASSWORD'),
    },
    'MOCK_SERVER': {
        'HOST': 'localhost',
        'PORT': _get_free_port(),
    },
    'BASE_PATH': os.path.dirname(os.path.normpath(__file__))
}


deform_client = Client(
    host=CONFIG['DEFORM']['HOST'],
    port=CONFIG['DEFORM']['PORT'],
    request_defaults=CONFIG['DEFORM']['REQUEST_DEFAULTS'],
    api_base_path=CONFIG['DEFORM']['API_BASE_PATH'],
    secure=CONFIG['DEFORM']['SECURE'],
)
deform_session_client = deform_client.auth(
    'session',
    deform_client.user.login(
        email=CONFIG['DEFORM']['EMAIL'],
        password=CONFIG['DEFORM']['PASSWORD']
    )
)
deform_session_project_client = deform_session_client.use_project(
    CONFIG['DEFORM']['PROJECT']
)
