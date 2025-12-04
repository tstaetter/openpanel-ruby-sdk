# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenPanel::SDK do
  let :tracker do
    OpenPanel::SDK::Tracker.new({ env: 'test' }, disabled: false)
  end

  let :user do
    iu = OpenPanel::SDK::IdentifyUser.new

    iu.profile_id = '123123'
    iu.email = 'tester@test.com'
    iu.first_name = 'Tester'
    iu.last_name = 'Test'
    iu.properties = { name: 'test' }
    iu
  end

  context 'tracking events' do
    it 'can track a test event' do
      response = tracker.track('test_event', payload: { name: 'test' })

      expect(response.status).to eq(200)
    end

    it 'can track with global properties' do
      tracker = OpenPanel::SDK::Tracker.new({ sdkName: 'ruby' }, disabled: false)
      response = tracker.track('test_event')

      expect(response.status).to eq(200)
    end
  end

  context 'filtering events' do
    it 'cannot track filtered events with lambda as filter' do
      filter = lambda { |payload|
        true if payload[:name] == 'test'
      }
      response = tracker.track('test_event', payload: { name: 'test' }, filter: filter)

      expect(response).to be_nil
    end
  end

  context 'identifying users' do
    it 'can identify a user' do
      response = tracker.identify(user)

      expect(response.status).to eq(200)
    end
  end

  context 'increment props' do
    it 'can increment visits' do
      response = tracker.increment_property(user)

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
      response = tracker.revenue user, 100, { currency: 'EUR' }

      expect(response.status).to eq(200)
    end
  end
end
