<a href="https://www.ultralytics.com/"><img src="https://raw.githubusercontent.com/ultralytics/assets/main/logo/Ultralytics_Logotype_Original.svg" width="320" alt="Ultralytics logo"></a>

# 🚀 Introduction

Welcome to the Ultralytics MATLAB Functions Repository! This repository serves as a central hub for commonly used functions essential across various Ultralytics projects developed in [MATLAB](https://www.mathworks.com/products/matlab.html). These scripts provide a foundational toolkit designed to assist in the development and research phases of [machine learning](https://www.ultralytics.com/glossary/machine-learning-ml) and [data analysis](https://www.ultralytics.com/glossary/data-analytics) tasks. Explore and utilize these utilities to streamline your workflow and accelerate your projects!

[![Ultralytics Actions](https://github.com/ultralytics/functions-matlab/actions/workflows/format.yml/badge.svg)](https://github.com/ultralytics/functions-matlab/actions/workflows/format.yml)
[![Ultralytics Discord](https://img.shields.io/discord/1089800235347353640?logo=discord&logoColor=white&label=Discord&color=blue)](https://discord.com/invite/ultralytics)
[![Ultralytics Forums](https://img.shields.io/discourse/users?server=https%3A%2F%2Fcommunity.ultralytics.com&logo=discourse&label=Forums&color=blue)](https://community.ultralytics.com/)
[![Ultralytics Reddit](https://img.shields.io/reddit/subreddit-subscribers/ultralytics?style=flat&logo=reddit&logoColor=white&label=Reddit&color=blue)](https://reddit.com/r/ultralytics)

For more information about Ultralytics, our mission, and the innovative work we do in AI, visit our official website: [https://www.ultralytics.com](https://www.ultralytics.com/).

## 📘 What is This Repository?

The [functions-matlab](https://github.com/ultralytics/functions-matlab) repository is a curated collection of MATLAB functions frequently employed within the Ultralytics ecosystem. These functions represent the building blocks used across numerous projects, promoting efficient [code reuse](https://en.wikipedia.org/wiki/Code_reuse) and maintaining consistency throughout our MATLAB codebase.

## 📋 Requirements

To effectively use the resources provided in this repository, please ensure you have the following installed:

-   [MATLAB](https://www.mathworks.com/products/matlab.html) version R2018a or newer.

## 📥 Installation

Getting started with these functions is straightforward:

1.  Clone this repository to your local machine using [Git](https://git-scm.com/):

    ```bash
    git clone https://github.com/ultralytics/functions-matlab
    ```

2.  Add the cloned repository directory to your MATLAB path. This allows MATLAB to locate and execute the functions. Launch MATLAB and run the following command, replacing `path_to_cloned_repo` with the actual path where you cloned the repository:

    ```matlab
    addpath(genpath('path_to_cloned_repo/functions-matlab'))
    % Example: addpath(genpath('/Users/username/Documents/MATLAB/functions-matlab'))
    ```
    For more details on managing the MATLAB path, see the official [MathWorks documentation](https://www.mathworks.com/help/matlab/ref/addpath.html).

## 🧰 How to Use

Once the repository is added to your MATLAB path, you can call any function directly from your MATLAB scripts or the command window, just like any built-in MATLAB function.

```matlab
% Example: Calling a hypothetical function 'ultralytics_preprocess' from the repository
processedData = ultralytics_preprocess(rawData);
disp('Data processed successfully using Ultralytics function.');
```

Refer to the specific function's documentation (usually included as comments within the `.m` file) for details on its usage, inputs, and outputs. Learn more about [calling functions in MATLAB](https://www.mathworks.com/help/matlab/learn-matlab/calling-functions.html).

## 🤝 How to Contribute

Contributions from the community are highly encouraged and appreciated! Whether it's fixing bugs, adding new utility functions, or improving documentation, your input helps make this resource better for everyone. Please review our [Contributing Guide](https://docs.ultralytics.com/help/contributing/) for guidelines on how to contribute effectively. Found a bug or have a suggestion? Open an issue on our [GitHub Issues](https://github.com/ultralytics/functions-matlab/issues) page.

We also value your feedback on Ultralytics products and initiatives. Please consider sharing your thoughts by filling out our [Survey](https://www.ultralytics.com/survey?utm_source=github&utm_medium=social&utm_campaign=Survey). A huge 🙏 thank you to all our contributors!

[![Ultralytics open-source contributors](https://raw.githubusercontent.com/ultralytics/assets/main/im/image-contributors.png)](https://github.com/ultralytics/ultralytics/graphs/contributors)

## ©️ License

Ultralytics provides two licensing options to accommodate different use cases:

-   **AGPL-3.0 License**: An [OSI-approved](https://opensource.org/) [open-source](https://opensource.org/osd) license ideal for students, researchers, and enthusiasts who wish to share improvements and collaborate openly. See the [LICENSE](https://github.com/ultralytics/functions-matlab/blob/main/LICENSE) file for the full terms.
-   **Enterprise License**: Designed for commercial applications, this license permits the integration of Ultralytics software and AI models into commercial products and services without the open-source requirements of AGPL-3.0. If your project requires an Enterprise License, please contact us through [Ultralytics Licensing](https://www.ultralytics.com/license).

## 📬 Get in Touch

If you encounter issues, have feature requests, or wish to contribute, please use the [GitHub Issues](https://github.com/ultralytics/functions-matlab/issues) tracker for this repository. For broader questions, discussions about Ultralytics projects, or to connect with the community, join our [Discord](https://discord.com/invite/ultralytics) server!

<br>
<div align="center">
  <a href="https://github.com/ultralytics"><img src="https://github.com/ultralytics/assets/raw/main/social/logo-social-github.png" width="3%" alt="Ultralytics GitHub"></a>
  <img src="https://github.com/ultralytics/assets/raw/main/social/logo-transparent.png" width="3%" alt="space">
  <a href="https://www.linkedin.com/company/ultralytics/"><img src="https://github.com/ultralytics/assets/raw/main/social/logo-social-linkedin.png" width="3%" alt="Ultralytics LinkedIn"></a>
  <img src="https://github.com/ultralytics/assets/raw/main/social/logo-transparent.png" width="3%" alt="space">
  <a href="https://twitter.com/ultralytics"><img src="https://github.com/ultralytics/assets/raw/main/social/logo-social-twitter.png" width="3%" alt="Ultralytics Twitter"></a>
  <img src="https://github.com/ultralytics/assets/raw/main/social/logo-transparent.png" width="3%" alt="space">
  <a href="https://youtube.com/ultralytics"><img src="https://github.com/ultralytics/assets/raw/main/social/logo-social-youtube.png" width="3%" alt="Ultralytics YouTube"></a>
  <img src="https://github.com/ultralytics/assets/raw/main/social/logo-transparent.png" width="3%" alt="space">
  <a href="https://www.tiktok.com/@ultralytics"><img src="https://github.com/ultralytics/assets/raw/main/social/logo-social-tiktok.png" width="3%" alt="Ultralytics TikTok"></a>
  <img src="https://github.com/ultralytics/assets/raw/main/social/logo-transparent.png" width="3%" alt="space">
  <a href="https://ultralytics.com/bilibili"><img src="https://github.com/ultralytics/assets/raw/main/social/logo-social-bilibili.png" width="3%" alt="Ultralytics BiliBili"></a>
  <img src="https://github.com/ultralytics/assets/raw/main/social/logo-transparent.png" width="3%" alt="space">
  <a href="https://discord.com/invite/ultralytics"><img src="https://github.com/ultralytics/assets/raw/main/social/logo-social-discord.png" width="3%" alt="Ultralytics Discord"></a>
</div>
