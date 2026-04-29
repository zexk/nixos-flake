{
  programs.aider-chat = {
		enable = true;
		settings = {
		# model
      model = "openai/gemma-4-e4b";
		# provider
			openai-api-base =  "http://127.0.0.1:8080/v1";	
			openai-api-key = "MOCK";
		# aider
			dark-mode = true;
			dirty-commits = false;
			show-model-warnings = false;
		};
	};
}
