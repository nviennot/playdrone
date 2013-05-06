class Stack::FindTokens < Stack::Base
  def initialize(stack,options={})
    @stack ||= ::Middleware::Builder.new do
      use Stack::FindTwitterTokens
      use Stack::FindAmazonTokens
      use Stack::FindFacebookTokens
      use Stack::FindLinkedinTokens
      use Stack::FindFoursquareTokens
      use Stack::FindBitlyv1Tokens
      use Stack::FindBitlyv2Tokens
      use Stack::FindYelpv1Tokens
      use Stack::FindYelpv2Tokens
      use Stack::FindFlickrTokens
      use Stack::FindGoogleMapsTokens
      use Stack::FindGoogleOauth2Tokens
      use stack
    end
    @options = options
  end
end
