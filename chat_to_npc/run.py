from transformers import pipeline
import torch
import os
import time



def main():
    model_name = "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B"
    device = 0 if torch.cuda.is_available() else -1
    pipe = pipeline("text-generation", model=model_name, device=device)

    print("AI Wizard initialized. Running loop 50 times.")
    
    file_location = os.getcwd()[:-11]

    print(file_location)

    input_file = (file_location + "read/input.txt")
    output_file = (file_location + "read/output.txt")
    
    # Initialize the previous input to be empty
    prev_input = ""
    counter = 0
    
    print('Initiated AI Prompt')

    while counter < 50:
        # Check if the input.txt file has been modified
        with open(input_file, "r") as file:
            current_input = file.read().strip()
        
        if current_input != prev_input:
            prompt = f"Respond as a drunk wizard and avoid repeating yourself {current_input}"
            response = pipe(prompt, max_length=75, do_sample=True, top_p=0.7, temperature=0.7, num_return_sequences=1, truncation=True)[0]["generated_text"]
            
            # Remove the unwanted string and current_input
            unwanted_string = "Respond as a drunk wizard and avoid repeating yourself "
            wizard_reply = response.replace(unwanted_string, "").replace(current_input, "").strip()

            # Limit the response to 1 sentence
            punctuations = ['.', '!', '?']
            sentence_count = 0
            limited_response = ""
            for char in wizard_reply:
                limited_response += char
                if char in punctuations:
                    sentence_count += 1
                    if sentence_count >= 2:
                        break

            with open(output_file, "w") as file:
                file.write(limited_response.strip())
            
            # Update the previous input
            prev_input = current_input
        
        # Wait for a short period before checking again
        time.sleep(2)
        counter += 1
        print(counter)

if __name__ == "__main__":
    main()
