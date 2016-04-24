import shutil
import tempfile
import os

from src.utils import CONFIG_DIR, save_settings
from tests.testutils import CONFIG


def before_all(context):
    # set random temp dir as home
    home = os.path.join(tempfile.gettempdir(), 'home/')
    try:
        os.makedirs(home)
    except OSError:
        pass
    os.chdir(home)


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
