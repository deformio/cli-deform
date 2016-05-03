import shutil
import tempfile
import os
from threading import Thread

from src.utils import CONFIG_DIR, save_settings
from tests.testutils import CONFIG
from tests.mock_server import app as mock_server_app


def before_all(context):
    # set random temp dir as home
    home = os.path.join(tempfile.gettempdir(), 'home/')
    try:
        os.makedirs(home)
    except OSError:
        pass
    os.chdir(home)

    # run mock server
    context.mock_server = Thread(
        target=mock_server_app.run,
        kwargs={
            'port': CONFIG['MOCK_SERVER']['PORT']
        }
    )
    context.mock_server.daemon = True
    context.mock_server.start()


def before_scenario(context, scenario):
    # remove config dir
    try:
        shutil.rmtree(CONFIG_DIR)
    except OSError:
        pass

    # set test settings
    if scenario.feature.name != 'deform settings':
        save_settings(
            api_host=CONFIG['DEFORM']['HOST'],
            api_secure=CONFIG['DEFORM']['SECURE'],
            api_request_defaults=CONFIG['DEFORM']['REQUEST_DEFAULTS'],
        )
