### imatch

* Descirbed at http://www.ir.iit.edu/~abdur/Research/Duplicate.html

### DESCRIPTION:

An implementation of the IMatch algorithm as described at http://www.ir.iit.edu/~abdur/Research/Duplicate.html

### FEATURES:

* Stemming via the 'stemmer' gem and :stemming option
* Stop words via the :stop_words option
* Built-in English lexicon

### KNOWN PROBLEMS:

* None, yet.

### REQUIREMENTS:

* Digest::SHA1
* Stemmer gem (Porter Stemmer implementation)

### INSTALL:

    gem install imatch

### DEVELOPERS:

    # Default settings (English lexicon, no stemming, no stop words)
    imatch = IMatch.new
    imatch.signature('your string here') # => Returns a string with the hex SHA1 signature

    # Add stop words
    imatch = IMatch.new(IMatch::DEFAULT_LEXICON_FILE, :stop_words => ['a'])
    imatch.signature("foo")
    # same result.
    imatch.signature("a foo")


    # Turn on stemming
    imatch = IMatch.new(IMatch::DEFAULT_LEXICON_FILE, :stemming => true)
    imatch.signature("follower")
    # same result.
    imatch.signature("followers")

### LICENSE:

Copyright 2010 Twitter, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
file except in compliance with the License. You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
