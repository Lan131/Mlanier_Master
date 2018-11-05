#http://guides.temple.edu/mining-twitter/scraping
#http://stackoverflow.com/questions/17905350/running-an-ipython-jupyter-notebook-non-interactively/17913858#17913858
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt 

data = pandas.read_csv("test.csv", header=0)
text = list(data.a)

sent=indicoio.sentiment(text)
index=np.linspace(1, len(sent),num=len(sent))

#df1 = pd.DataFrame(sent, columns=['sent'])
#df2 = pd.DataFrame(index, columns=['index'])

#df = pd.concat([df1, df2], join='outer', axis=1)
sns.tsplot(sent, err_style="boot_traces", n_boot=500)
df.set_index('index').plot()
plt.show()
indicoio.config.api_key = 'my_api_key'


# single example
indicoio.sentiment("I love writing code!")

# batch example
indicoio.sentiment([
    "I love writing code!",
    "Alexander and the Terrible, Horrible, No Good, Very Bad Day"
])

import indicoio

# option 1: pass configuration as a function argument
print(indicoio.sentiment('indico is so easy to use!', api_key="75b93ed62df0c77a6e58c8ebb1bb71f2", cloud="YOUR_SUBDOMAIN"))

# option 2: set module variable
indicoio.config.api_key = '75b93ed62df0c77a6e58c8ebb1bb71f2'
indicoio.config.cloud = 'YOUR_SUBDOMAIN'
print(indicoio.sentiment('indico is so easy to use!'))


import indicoio
indicoio.config.api_key = '75b93ed62df0c77a6e58c8ebb1bb71f2'

# Version >= 0.9.0
indicoio.sentiment(['indico is so easy to use!', 'Still really easy, yiss'])

# Version < 0.9.0
indicoio.batch_sentiment(['indico is so easy to use!', 'Still really easy, yiss'])

#https://indico.io/docs

#sentiment(data, [api_key], [cloud], [language])
#sentiment_hq(data, [api_key], [cloud])
#text_tags(data, [api_key], [cloud], [top_n], [threshold], [independent])
#language(data, [api_key], [cloud])
#political(data, [api_key], [cloud], [top_n], [threshold])
#keywords(data, [api_key], [version], [cloud], [top_n], [threshold], [relative]
#people(data, [api_key], [cloud], [threshold])
#places(data, [api_key], [cloud], [threshold])
#organizations(data, [api_key], [cloud], [threshold])
#twitter_engagement(data, [api_key], [cloud])
#personality(data, [api_key], [cloud])
#relevance(data, queries, [api_key], [cloud])
#text_features(data, [api_key], [cloud])
#emotion(data, [api_key], [cloud], [top_n], [threshold])
#intersections(data, apis, [api_key], [cloud])
#analyze_text(data, apis, [api_key], [cloud])



# batch example
indicoio.analyze_text(
    [
        "Democratic candidate Hillary Clinton is excited for the upcoming election.",
        "Bill Clinton joins President Obama for a birthday golf game at Marthas Vineyard."
    ],
    apis=['sentiment_hq', 'political']
)
# splitting


import indicoio

indicoio.sentiment('This sentence is awful. This sentence is great!', split='sentence')


#custom training
from indicoio.custom import Collection
indicoio.config.api_key = '75b93ed62df0c77a6e58c8ebb1bb71f2'

collection = Collection("collection_name")

# Add Data
collection.add_data([["text1", "label1"], ["text2", "label2"], ...])

# Training
collection.train()

# Telling Collection to block until ready
collection.wait()

# Done! Start analyzing text
collection.predict("indico is so easy to use!")


#images
import indicoio

indicoio.fer('https://IMAGE_URL')
Specifying Filepath

import indicoio

indicoio.fer('FILEPATH')
Formatting images using skimage

import skimage.io
import indicoio

pixel_array = skimage.io.imread('FILEPATH')

indicoio.fer(pixel_array)
Formatting images using PIL and numpy

from PIL import Image
import numpy as np
import indicoio

image = Image.load('FILEPATH')
pixel_array = np.array(image)

indicoio.fer(pixel_array)


#facial recognition

import indicoio
indicoio.config.api_key = '75b93ed62df0c77a6e58c8ebb1bb71f2'

# single example
indicoio.fer("<IMAGE>")

# batch example
indicoio.fer([
    "<IMAGE>",
    "<IMAGE>"
])

#multiple
import indicoio
indicoio.config.api_key = '75b93ed62df0c77a6e58c8ebb1bb71f2'

# single example
indicoio.analyze_image("<IMAGE>", apis=["image_features", "fer","content_filtering])

# batch example
indicoio.analyze_image([
    "<IMAGE>", 
    "<IMAGE>"
], apis=["image_features", "fer"])
