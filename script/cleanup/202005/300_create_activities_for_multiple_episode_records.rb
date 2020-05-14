# frozen_string_literal: true

activities = Activity
# For test
# activities = User.find_by(username: "shimbaco").following_activities

activities.with_action(:create_multiple_episode_records).find_each do |activity|
  puts "----- Activity: #{activity.id}"

  user = activity.user
  multiple_episode_record = activity.trackable
  episode_records = multiple_episode_record.episode_records.preload(episode: :work)

  ActiveRecord::Base.transaction do
    activity_group = user.activity_groups.create!(
      activity_type: :episode_record,
      single: false,
      created_at: multiple_episode_record.created_at,
      updated_at: multiple_episode_record.updated_at
    )

    episode_records.each do |episode_record|
      episode = episode_record.episode
      work = episode.work

      user.activities.create!(
        action: :create_episode_record,
        activity_type: :episode_record,
        recipient: episode,
        trackable: episode_record,
        activity_group: activity_group,
        episode: episode,
        episode_record: episode_record,
        work: work,
        created_at: episode_record.created_at,
        updated_at: episode_record.updated_at
      )
    end

    activity.destroy!
  end
end
