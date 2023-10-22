import logging
import yaml
from pathlib import Path
import subprocess

_LOGGER = logging.getLogger(__name__)

class MissingRequiredKey(Exception):
    pass

class RecipeProcessingFailed(Exception):
    pass

class RecipeProcessor:
    """
    A class to process tasks defined in recipe YAML file.
    """

    recipe : yaml
    PLACEHOLDER_CURRENT_SOURCE = "mpysource"

    def __init__(self, recipePath):
        _LOGGER.debug(f"Loading recipe: {recipePath}")
        self.fileName = str(recipePath)
        with recipePath.open() as file:
            self.recipe = yaml.safe_load(file)

    # Creates a directory.
    # Returns true if successful.
    # Throws MissingRequiredKey if there is directory name missing (or not string).
    def stepMakeDirectory(self, stepData) -> bool:
        
        try:
            dirName = stepData["name"]
        except KeyError:
            _LOGGER.error("Directory name missing.")
            raise MissingRequiredKey

        if type(dirName) != str:
            _LOGGER.error("Directory name is not a string.")
            raise MissingRequiredKey

        _LOGGER.debug(f"Creating directory '{dirName}'")
        Path(dirName).mkdir(exist_ok = True)
        
        return True

    def stepRun(self, stepData) -> bool:

        _LOGGER.info("Starting run step...")

        try:
            execName             = stepData["executable"]
            globalSource : Path  = stepData["global_source"]

        except KeyError:
            _LOGGER.error("Missing required key found during elaboration of run step. Halting.")
            return False
        
        params = []
        try:
            # Check if there is a source placeholder in params and replace accordingly.
            for par in stepData["params"]:
                if par == self.PLACEHOLDER_CURRENT_SOURCE:
                    if globalSource == None:
                        _LOGGER.warning(f"Using placeholder {self.PLACEHOLDER_CURRENT_SOURCE} even when no global sources are specified. Parameter ignored.")
                    else:
                        params.append(str(globalSource.resolve()))
                else:
                    params.append(par)
        except KeyError:
            pass

        try:
            assertReturnCode = stepData["assert"]["return_code"] 
        except KeyError:
            assertReturnCode = None

        try:
            assertOutputNotCont = stepData["assert"]["output"]["not_contains"]
        except KeyError:
            assertOutputNotCont = []
        
        try:
            assertOutputCont    = stepData["assert"]["output"]["contains"]
        except KeyError:
            assertOutputCont    = []

        _LOGGER.debug(f"Elaborated params: {params}")
        
        execWithParams = [execName, *params]
        _LOGGER.debug(f"Running: '{execWithParams}'")

        pipes = subprocess.Popen(
            execWithParams,
            stdout = subprocess.PIPE,
            stderr = subprocess.PIPE
        )

        stdout, stderr = pipes.communicate()
        stdout = stdout.decode('utf-8')
        stderr = stderr.decode('utf-8')

        if stdout: _LOGGER.info(f"STDOUT: {stdout}")
        if stderr: _LOGGER.info(f"STDERR: {stderr}")

        if assertReturnCode:
            if pipes.returncode != assertReturnCode:
                _LOGGER.info(f"Assertion for return code failed. Expected {assertReturnCode} got {pipes.returncode}")
                return False
            
        if type(assertOutputCont) == list:
            for outCont in assertOutputCont:
                if not outCont in (stdout + stderr):
                    _LOGGER.info(f"Assertion failed for program output condition: '{outCont}' not found in output.")
                    return False
        
        if type(assertOutputNotCont) == list:
            for outCont in assertOutputNotCont:
                if outCont in (stdout + stderr):
                    _LOGGER.info(f"Assertion failed for program output condition: '{outCont}' was found in output.")
                    return False
        
        _LOGGER.info("Step passed.")
        return True

    stepParsers : dict = {
        "make_directory" : stepMakeDirectory,
        "run" : stepRun
    }

    # Check if the file version is compatible.
    def __checkVersion(self, metadata) -> bool:
        return "type" in metadata and metadata["type"] == "makepy recipe" and "version" in metadata and metadata["version"] == 0.1
    
    # Elaborate all steps in recipe.
    # Throws RecipeProcessingFailed exception if there is a syntax error in the recipe.
    def __elaborateSteps(self, currentSource) -> bool:
        for step in self.steps:
            try:
                stepName = list(step.keys())[0]
                # Merge step's parameters with current source from list (if specified).
                stepParams = step[stepName] | {"global_source" : currentSource}
                if not self.stepParsers[stepName](self, stepParams):
                    _LOGGER.info(f"Step '{stepName}' failed, returning false.")
                    return False
            except KeyError:
                _LOGGER.error(f"Unsupported step '{stepName}', halting.")
                raise RecipeProcessingFailed
        
        return True

    def __validateType(self, file : Path, fileType : str) -> bool:
        if fileType == "verilog":
            return file.suffix == ".v"
        else:
            return False

    # Process the recipe.
    # Returns true when all actions in the recipe succeeded, otherwise false.
    # Throws RecipeProcessingFailed exception if there is a syntax error in the recipe.
    def process(self) -> bool:
        try:
            if not self.__checkVersion(self.recipe["metadata"]):
                _LOGGER.error("Recipe is not compatible with this processor.")
                return False
        except (KeyError, TypeError) as e:
            _LOGGER.error("Recipe is missing metadata.")
            return False

        # Load required keys.
        try:
            self.name = self.recipe["recipe"]["name"]
            self.steps = self.recipe["recipe"]["steps"]
        except KeyError:
            _LOGGER.error("Recipe does not contain required keys.")
            return False
        
        # Load optional keys.
        try:
            self.comment = self.recipe["recipe"]["comment"]
        except KeyError:
            self.comment = "N/A"
        
        try:
            self.printLogs = self.recipe["recipe"]["print_logs"]
        except KeyError:
            self.printLogs = "error"
        
        try:
            for source in self.recipe["recipe"]["sources"]:
                srcPath = Path(source["path"])
                if srcPath.is_dir():
                    self.sources = [file for file in srcPath.iterdir() if file.is_file() and self.__validateType(file, source["type"])]
                else:
                    self.sources = [srcPath]
            _LOGGER.debug(f"Loaded sources: {self.sources}")
        except KeyError:
            self.sources = [ None ]
            _LOGGER.debug(f"No sources specified, inserted dummy one: {self.sources}")
        
        print(f"📜 Running recipe '{self.name}' ({self.fileName})...")
        _LOGGER.debug(f"Recipe comment: {self.comment}")

        for source in self.sources:

            if source != None:
                print(f"📜📄 Running steps for source file '{source}'")

            if not self.__elaborateSteps(source):
                print(f"📜❌ File '{source}' failed")
                return False
            
            print(f"📜✅ File '{source}' passed")
            
        print(f"✅ Recipe '{self.name}' passed successfully.")
        return True
        
