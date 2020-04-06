import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="controller_site", 
    version="0.0.1",
    author="Faruk Hammoud",
    author_email="farukhammoud@student-cs.fr",
    description="Enables connection to ControllerApp",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://gitlab.viarezo.fr/2019hammoudf/controller",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)