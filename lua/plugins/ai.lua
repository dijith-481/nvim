-- return {}
return {
	{
		"milanglacier/minuet-ai.nvim",
		lazy = true,
		event = { "VeryLazy", "InsertEnter" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("minuet").setup({
				blink = {
					enable_auto_complete = false,
				},
				-- provider = "openai_compatible",
				provider = "gemini",
				openai_compatible = {
					model = "llama3-70b-8192",
					system = "see [Prompt] section for the default value",
					few_shots = "see [Prompt] section for the default value",
					chat_input = "See [Prompt Section for default value]",
					end_point = "https://api.groq.com/openai/v1/chat/completions",
					api_key = "GROQ_API_KEY",
					name = "Groq",
					stream = true,
					optional = {
						stop = nil,
						max_tokens = nil,
					},
				},
				provider_options = {
					gemini = {
						model = "gemini-2.0-flash",
						optional = {
							generationConfig = {
								maxOutputTokens = 256,
							},
							safetySettings = {
								{
									-- HARM_CATEGORY_HATE_SPEECH,
									-- HARM_CATEGORY_HARASSMENT,
									-- HARM_CATEGORY_SEXUALLY_EXPLICIT,
									category = "HARM_CATEGORY_DANGEROUS_CONTENT",
									threshold = "BLOCK_ONLY_HIGH",
								},
							},
						},
					},
				},
			})
		end,
	},
}
