## Imbalanced Data

An imbalanced dataset is a dataset where one or more labels make up the majority of the dataset, leaving far fewer examples of other labels.

This problem applies to both classification and regression tasks.

- Regression : examples with outlier values that are either much lower or higher than median/average of the data.

    - e.g : Predict prices for houses. Houses worth > $10M are rare.

In many scenarios, getting more data for the minority class may be impractical or hard to acquire because the data is inherently imbalanced.

- e.g., fraud detection and detection of rare diseases.

### 1. Why it causes problems?

The model cannot learn to predict the minority class well because of class imbalance.

- Model is only able to learn a simple heuristic (e.g. always predict the dominate class) and it get stuck in a suboptimal solution.

- An accuracy of over 90% can be misleading because the model may not have predict power on the rare class.
    - e.g. 95% of labels is in one class.

- Often, the minority class is more important than the majority class. A wrong prediction on an example of the minority class is more costly than a wrong prediction on an example of the majority class.
    - e.g., Missing a fraudulent transaction is 100x more costly than misclassifying a legitimate example as fraud.

### 2. How to deal with imbalanced data?

- Data Level : Resampling
- Model-Level
- Metric-Level

#### 2-1 Resampling

Change the distribution of the training data to reduce the level of class imbalanced.

- Over-sampling(Upsampling) : Add more examples to the minority class
    - Random over-sampling
        Randomly make copies of the minority class until a ratio is reached.

        > Simply making replicas may make the model overfit to the few examples
    
    - Generate synthetic examples
        - SMOTE (synthetic minority oversamplingtechnique) - creates synthetic examples of the rare class by combining original examples. It does this using a nearest neighbors approach.

        > It can prevent the overfitting    caused by random oversampling because it does not use original examples.

- Under-sampling(Downsampling) : Remove examples from the majority class
    - Random under-sampling

        Randomly removes of the majority class until a ratio is reached.

        > Random under-sampling may make the resulting dataset too small for a model to learn from, so it only works when we have enough number of examples (at least thousands of samples) in the minority class.

    - Tomek links

        Find pairs of examples from opposite class that are close in proximity and remove the sample of the majority class in each pair.

        It may help make the decision boundary more clear and the model learn the boundary better. But the model may not learn from the subtleties of the true decision boundary.

    > Resampling method is a good starting point, but it runs the risk of overfitting training data (over-sampling) and losing important information from removing data (under-sampling)

#### 2-2 Model-Level Methods

- Make the model more robust to class imbalance.
- Does not change the distribution of the training data.

    <b>Update loss function</b>
    
    - Design a loss function that penalizes the wrong classification of the minority class more than the wrong classifications of the majority class.
    - Forces the model to treat specific classes with more weight than others during training.
        
        - e.g. Class-balanced loss - make the weight of each class inversely proportional to the number of samples in that class.

    <b>Select appropriate algorithms</b>
    - Tree based models work well on tasks involving small and imbalanced datasets.
    - Logistic regression is able to handle class imbalanced relatively well in a standalone manner. Adjust the probability threshold to improve the accuracy for predicting the minority class.

    <b>Combine multiple techniques</b>
    1. Under-sampling + ensemble
        
        Use all samples of the minority class and a subset of the majority class to train multiple models and then ensemble those models.

    2. Under-sampling + Update loss function

        Under-sample the majority class until a ratio is reached, calculate the new weights for both classes, then pass the new weights to the loss function of the model.     


#### 2-3 Evaluation Metrics

Choose appropriate evaluation metrics for the task.

> We should use unsampled data instead of resampled data to evaluate the model because using the later will cause the model to overfit the resampled distribution. The test data should provide an accurate representation of the original dataset.

- Accuracy is misleading when classes are imbalanced - Performance of the model on the majority class will dominate the metric.
    - Consider using accuracy for each class individually.

- Precision, recall, and F1 measures a model's performance with respect to the positive class in a binary classification problem

- Precision-Recall curve - identify a threshold that works best for the dataset. It gives more importance to the positive class (put emphasis on how many predictions the model got right out of the total number it predicted to be positive), which is helpful for dealing with imbalanced data.