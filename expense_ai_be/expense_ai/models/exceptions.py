class UnsafeAIOutputError(Exception):
    """Custom exception for specific errors."""

    def __init__(self, message, code=None):
        self.message = message
        self.code = code
        super().__init__(self.message)

    def __str__(self):
        if self.code:
            return f"[Error {self.code}]: {self.message}"
        else:
            return self.message
