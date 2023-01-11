require 'httparty'
require 'json'
require 'pry'

class EndPoints
  def self.repo
    "https://api.github.com/repos/pocketzs/little-esty-shop"
  end

  def self.contributors
    "https://api.github.com/repos/Pocketzs/little-esty-shop/contributors" #{/collaborator}
  end

  def self.collaborators
    "https://api.github.com/repos/Pocketzs/little-esty-shop/collaborators" #{/collaborator}
  end

  def self.commits(person)
    "https://api.github.com/repos/Pocketzs/little-esty-shop/commits?author=#{person}" #{/sha}
  end

  def self.pulls(state)
    "https://api.github.com/repos/Pocketzs/little-esty-shop/pulls?state=#{state}"
  end
end

class GithubService
  attr_reader :data

  def initialize(url)
    @data = get_url(url)
  end
  
  def get_url(url)
    # open unencrypted credentials file and call it github: tolken (secret)
    # to open the credentials file we want to do rails credentials:edit, then add the keys
    # response = HTTParty.get(url, headers: { "User-Agent" => "Pocketzs", "Authorization" => "Token #{Rails.application.credentials.config[:github]}")
    response = HTTParty.get(url)
    parsed_info(response)
  end

  def parsed_info(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end

class Contributors
  attr_reader :contributors
  def initialize(data)
    @contributors = data.map do |contributor|
      contributor = contributor[:login] 
    end
  end
end

class RepositoryName
  attr_reader :name
  def initialize(data)
    @name = data[:name]
  end
end

class RepositoryCommits
  attr_reader :commits
  def initialize(data)
    @commits = data.count
  end
end

class RepositoryPullRequests
  attr_reader :count
  def initialize(data)
    @count = data.count
  end
end

# Repository Name
repo = GithubService.new(EndPoints.repo)
repo_name = RepositoryName.new(repo.data)

# Contributor Names
contributors = GithubService.new(EndPoints.contributors)
contributor_names = Contributors.new(contributors.data)

# Commit Descriptions In An Array For Specific User
commits = GithubService.new(EndPoints.commits("jlweave"))
commits_count = RepositoryCommits.new(commits.data)

# Pull Request Count
pulls = GithubService.new(EndPoints.pulls("closed"))
pr_count = RepositoryPullRequests.new(pulls.data)
binding.pry