require 'webmock/cucumber'


WebMock.disable_net_connect!(allow: %r{__identify__})