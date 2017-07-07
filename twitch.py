"""
Twitch API Module.

This module implements only those parts of the Twitch API needed for the
twitchalyze app to function. It is not a general purpose SDK.

This module is written against Version 5 of the Twitch API.
"""

import json
import requests

# Read in user configuration
with open('.twitchalyze') as data_file:
    CONFIG = json.load(data_file)

# Set up a new request session
S = requests.Session()
S.headers.update({
    'Client-ID': CONFIG["client_id"],
    'Accept': 'application/vnd.twitchtv.v5+json'
})


def _url(path):
    return CONFIG["api_url"] + path

##
# Twitch API calls


def streams(channel, game, stream_type):
    """
    Get live streams.

    https://dev.twitch.tv/docs/v5/reference/streams/#get-live-streams
    """
    query = {
        'channel': channel,
        'game': game,
        'type': stream_type,
        'limit': CONFIG["record_limit"],
        'offset': 0
    }

    return S.get(_url('/streams/'), params=query)
