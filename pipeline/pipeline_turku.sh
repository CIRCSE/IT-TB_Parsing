python tree_combiner_no_weigth.py tested_MLP_R-to-L.conll tested_SVM_R-to-L.conll tested_MLP_L-to-R.conll tested_turku.conll > combined-turku.conll

python conllx_evaluator.py combined-turku.conll Treebank_Test.conll
