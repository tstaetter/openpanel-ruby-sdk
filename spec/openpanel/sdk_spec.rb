# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe OpenPanel::SDK do
  let :profile_id do
    SecureRandom.hex(8)
  end

  let :tracker do
    OpenPanel::SDK::Tracker.new({ env: 'test' }, disabled: false)
  end

  let :user do
    iu = OpenPanel::SDK::IdentifyUser.new

    iu.profile_id = profile_id
    iu.email = 'tester@test.com'
    iu.first_name = 'Tester'
    iu.last_name = 'Test'
    iu.properties = { name: 'test' }
    iu
  end

  context 'tracking events' do
    it 'can track a test event' do
      response = tracker.track('test_event', profile_id: profile_id, payload: { name: 'test' })

      expect(response.status).to eq(200)
    end

    it 'can track with global properties' do
      tracker = OpenPanel::SDK::Tracker.new({ sdkName: 'ruby' }, disabled: false)
      response = tracker.track('test_event', profile_id: profile_id)

      expect(response.status).to eq(200)
    end
  end

  context 'filtering events' do
    it 'cannot track filtered events with lambda as filter' do
      filter = lambda { |payload|
        true if payload[:name] == 'test'
      }
      response = tracker.track('test_event', profile_id: profile_id, payload: { name: 'test' }, filter: filter)

      expect(response).to be_nil
    end
  end

  context 'identifying users' do
    it 'can identify a user' do
      response = tracker.identify(user)

      expect(response.status).to eq(200)
    end
  end

  context 'increment/decrement props' do
    it 'can increment visits' do
      response = tracker.increment_property(user)

      expect(response.status).to eq(200)
    end

    it 'can decrement visits' do
      response = tracker.decrement_property(user)

      expect(response.status).to eq(200)
    end
  end

  context 'headers' do
    it 'can set the headers' do
      tracker.set_header 'test', 'test'

      expect(tracker.headers['test']).to eq 'test'
    end
  end

  context 'revenue' do
    it 'can track revenues' do
      response = tracker.revenue user: user, amount: 100, properties: { currency: 'EUR' }

      expect(response.status).to eq(200)
    end
  end

  context 'device id' do
    it 'can fetch device id' do
      id = tracker.fetch_device_id

      expect(id).to_not be_empty
    end
  end
end
