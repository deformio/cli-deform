import os, json


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
    'BASE_PATH': os.path.dirname(os.path.normpath(__file__))
}
