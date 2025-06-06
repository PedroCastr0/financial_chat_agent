import json

import pandas as pd
from datasets import Dataset
from sklearn.model_selection import train_test_split
from transformers import (
    AutoModelForSequenceClassification,
    AutoTokenizer,
    EarlyStoppingCallback,
    Trainer,
    TrainingArguments,
)

# INFO: Get a pretrained model for NLP and add our context
BASE_MODEL_NAME = "distilbert-base-uncased"
DATA_PATH = "classify_query/bank_queries.csv"
FINE_TUNED_MODEL_PATH = "classify_query/fine_tuned_model"

df = pd.read_csv(DATA_PATH)

unique_labels = df["label"].unique().tolist()
label_dict = {label: i for i, label in enumerate(unique_labels)}
df["label"] = df["label"].map(label_dict)

print(f"Dataset carregado com {len(df)} amostras.")
print(f"Encontradas {len(unique_labels)} classes: {unique_labels}")

train_df, eval_df = train_test_split(
    df, test_size=0.2, random_state=42, stratify=df["label"]
)

train_dataset = Dataset.from_pandas(train_df)
eval_dataset = Dataset.from_pandas(eval_df)

print(
    f"\nDataset dividido em {len(train_dataset)} amostras de treino e {len(eval_dataset)} de avaliação."
)

tokenizer = AutoTokenizer.from_pretrained(BASE_MODEL_NAME)


def tokenize_function(examples):
    return tokenizer(
        examples["text"], padding="max_length", truncation=True, max_length=64
    )


train_dataset = train_dataset.map(tokenize_function, batched=True)
eval_dataset = eval_dataset.map(tokenize_function, batched=True)


model = AutoModelForSequenceClassification.from_pretrained(
    BASE_MODEL_NAME, num_labels=len(unique_labels)
)

training_args = TrainingArguments(
    output_dir="classify_query/training_output",
    num_train_epochs=100,
    per_device_train_batch_size=16,
    per_device_eval_batch_size=16,
    learning_rate=2e-5,
    weight_decay=0.01,
    eval_strategy="epoch",
    save_strategy="epoch",
    logging_steps=10,
    load_best_model_at_end=True,
    metric_for_best_model="eval_loss",
    greater_is_better=False,
)

early_stopping = EarlyStoppingCallback(early_stopping_patience=10)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=eval_dataset,
    tokenizer=tokenizer,
    callbacks=[early_stopping],
)

print("\nIniciando o treinamento do modelo...")
trainer.train()
print("Treinamento concluído!")

print("\nSalvando o melhor modelo em:", FINE_TUNED_MODEL_PATH)
trainer.save_model(FINE_TUNED_MODEL_PATH)

with open(f"{FINE_TUNED_MODEL_PATH}/label_dict.json", "w") as f:
    json.dump(label_dict, f)

print("\n✅ Processo de fine-tuning concluído!")
