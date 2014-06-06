#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
Bundler.require :default
require 'logger'
require 'json'

repo_dir = ARGV.first

git = Git.open(repo_dir, :log => Logger.new(STDOUT))


class CommitRepresenter
  attr_reader :commit

  def initialize(commit)
    @commit = commit
  end

  def represent
    {
      sha: commit.sha,
      parent_sha: commit.parent ? commit.parent.sha : nil,
      message: commit.message
    }
  end

end

binding.pry

get '/' do
  redirect '/index.html'
end

get '/commits.json' do
  git.log(100).collect {|commit| CommitRepresenter.new(commit).represent}.to_json
end
