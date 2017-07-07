# A JQ script to become familiar with the Twitch API

# Call using

# curl -N -s -H 'Accept: application/vnd.twitchtv.v5+json' \
# -H 'Client-ID: $twitch_client_id' \
# -X GET 'https://api.twitch.tv/kraken/streams/?game=creative&limit=100&offset=[0-500:100]' | \
# jq -C -s -f tw_stream.jq | less

[
  (
    { stats:
      (
        ( map(._total?) 
          | first ) as $streamcount

        | .
          | map(.streams[]? 
          | .viewers) 
          | (reduce .[] as $i (0; . + $i)) as $viewercount

        | { streamers_online: $streamcount,
            viewers_online: $viewercount }
        )
    }
  ),
  ( 
    { streams_live: 
      map(.streams[]?
      | { channel: .channel.display_name, 
          playing: .game,
          status: .channel.status, 
          start: .created_at, 
          viewers: .viewers, 
          stream_type: .stream_type,
          followers: .channel.followers,
          partner: .channel.partner, 
          url: .channel.url, 
          description: .channel.description } )
    }
  )
]
