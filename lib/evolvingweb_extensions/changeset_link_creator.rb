module EvolvingWebExtensions
  module ChangesetLinkCreator
    def self.create_link (changeset)
      repository_url = changeset.repository.clone_url
      if repository_url.start_with? "http"
        repository_url = repository_url.gsub(/\.git$/, "")
        repository_url = repository_url.gsub(/\/$/, "")
      end
      if repository_url.start_with? "git@"
        repository_url = repository_url.gsub(/:/, "/")
        repository_url = repository_url.gsub(/git@/, "https://")
        repository_url = repository_url.gsub(/\.git$/, "")
      end
      if repository_url
        return "#{repository_url}/commit/#{changeset.revision}"
      end
      return nil
    end
  end
end
