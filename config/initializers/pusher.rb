# Production is set automatically on Heroku

if Rails.env.development?
  Pusher.app_id = '33504'
  Pusher.key    = '3379d6e6ccdeed1c69d1'
  Pusher.secret = 'aa57b5fc025a941fdb73'
end
