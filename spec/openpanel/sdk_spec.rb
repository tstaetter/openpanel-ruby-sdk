# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenPanel::SDK do
  let :tracker do
    OpenPanel::SDK::Tracker.new
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
end
