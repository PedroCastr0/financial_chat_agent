from transformers import AutoModelForSequenceClassification, AutoTokenizer
import torch
import json

model_path = "classify_query/fine_tuned_model"
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = AutoModelForSequenceClassification.from_pretrained(model_path)

with open(f"{model_path}/label_dict.json") as f:
    label_dict = json.load(f)

inv_label_dict = {v: k for k, v in label_dict.items()}


def classify_query(query, top_k=1):
    inputs = tokenizer(
        query, return_tensors="pt", truncation=True, padding=True, max_length=128
    )
    with torch.no_grad():
        outputs = model(**inputs)

    probs = torch.nn.functional.softmax(outputs.logits, dim=1)[0]
    topk_values, topk_indices = torch.topk(probs, k=min(top_k, len(inv_label_dict)))

    results = []
    for value, idx in zip(topk_values.numpy(), topk_indices.numpy()):
        category = inv_label_dict.get(idx, "Desconhecido")
        confidence = value.item() * 100
        results.append((category, confidence))

    if top_k == 1:
        return results[0]
    else:
        return results
