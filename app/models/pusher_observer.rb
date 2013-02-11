class PusherObserver < ActiveRecord::Observer
  observe :site, :page

  def after_create(record)
    push(:created, record)
  end

  def after_update(record)
    push(:updated, record)
  end

  def after_counter_update(record)
    push(:updated, record)
  end

  def after_destroy(record)
    push(:destroyed, record)
  end

  def push(event, record)
    begin
      record = record.decorate
      serializer = record.active_model_serializer.new(record)
      Pusher.delay.trigger(record.pusher_channel, event, serializer.to_json)
    rescue Pusher::Error
    end
  end
end
