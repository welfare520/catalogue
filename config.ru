# encoding: UTF-8

require 'json'
require 'sinatra'
require "sinatra/namespace"
require 'yaml'
require 'virtus'
require 'fileutils'

ENV['RACK_ENV'] ||= 'development'

Dir.glob('./{config,lib,models,helpers,controllers}/*.rb').each { |file| require file }

run ApplicationController
