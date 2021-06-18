python tree_combiner_no_weigth.py tested_MLP_R-to-L.conll tested_SVM_R-to-L.conll tested_MLP_L-to-R.conll ics_thom-sent_tested.conll > combined-icspas.conll

python conllx_evaluator.py combined-icspas.conll Treebank_Test.conll
