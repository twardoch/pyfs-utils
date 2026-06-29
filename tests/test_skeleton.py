import pytest
import sys
from unittest.mock import patch
from io import StringIO

from pyfs_utils.skeleton import fib, main, parse_args, setup_logging, run
from pyfs_utils import __version__

__author__ = "Adam Twardoch"
__copyright__ = "Adam Twardoch"
__license__ = "CC0-1.0"


class TestFibonacci:
    """Test class for Fibonacci function"""
    
    def test_fib_basic(self):
        """Test basic Fibonacci sequences"""
        assert fib(1) == 1
        assert fib(2) == 1
        assert fib(3) == 2
        assert fib(4) == 3
        assert fib(5) == 5
        assert fib(6) == 8
        assert fib(7) == 13
        assert fib(8) == 21
        assert fib(9) == 34
        assert fib(10) == 55
    
    def test_fib_edge_cases(self):
        """Test edge cases and error conditions"""
        with pytest.raises(AssertionError):
            fib(-10)
        with pytest.raises(AssertionError):
            fib(0)
        with pytest.raises(AssertionError):
            fib(-1)
    
    def test_fib_large_numbers(self):
        """Test with larger numbers"""
        assert fib(15) == 610
        assert fib(20) == 6765
    
    def test_fib_performance(self):
        """Test performance with reasonably large numbers"""
        import time
        start = time.time()
        result = fib(100)
        end = time.time()
        assert result > 0
        assert end - start < 1.0  # Should complete in less than 1 second


class TestCLI:
    """Test class for CLI functionality"""
    
    def test_main_basic(self, capsys):
        """Test basic CLI functionality"""
        main(["7"])
        captured = capsys.readouterr()
        assert "The 7-th Fibonacci number is 13" in captured.out
    
    def test_main_different_numbers(self, capsys):
        """Test CLI with different numbers"""
        main(["1"])
        captured = capsys.readouterr()
        assert "The 1-th Fibonacci number is 1" in captured.out
        
        main(["10"])
        captured = capsys.readouterr()
        assert "The 10-th Fibonacci number is 55" in captured.out
    
    def test_parse_args_basic(self):
        """Test argument parsing"""
        args = parse_args(["42"])
        assert args.n == 42
        assert args.loglevel is None
    
    def test_parse_args_verbose(self):
        """Test verbose argument parsing"""
        args = parse_args(["-v", "42"])
        assert args.n == 42
        assert args.loglevel == 20  # logging.INFO
        
        args = parse_args(["-vv", "42"])
        assert args.n == 42
        assert args.loglevel == 10  # logging.DEBUG
    
    def test_parse_args_version(self, capsys):
        """Test version argument"""
        with pytest.raises(SystemExit):
            parse_args(["--version"])
        captured = capsys.readouterr()
        assert __version__ in captured.out
    
    def test_parse_args_help(self, capsys):
        """Test help argument"""
        with pytest.raises(SystemExit):
            parse_args(["--help"])
        captured = capsys.readouterr()
        assert "Fibonacci demonstration" in captured.out
    
    def test_setup_logging(self):
        """Test logging setup"""
        import logging
        
        # Test that setup_logging doesn't raise an error
        setup_logging(logging.INFO)
        setup_logging(logging.DEBUG)
    
    def test_run_function(self):
        """Test the run function entry point"""
        with patch.object(sys, 'argv', ['prog', '5']):
            with patch('sys.stdout', new_callable=StringIO) as mock_stdout:
                run()
                output = mock_stdout.getvalue()
                assert "The 5-th Fibonacci number is 5" in output


class TestIntegration:
    """Integration tests"""
    
    def test_full_cli_workflow(self, capsys):
        """Test complete CLI workflow"""
        main(["-v", "12"])
        captured = capsys.readouterr()
        assert "The 12-th Fibonacci number is 144" in captured.out
    
    def test_error_handling(self, capsys):
        """Test error handling in CLI"""
        with pytest.raises(AssertionError):
            main(["0"])
        
        with pytest.raises(AssertionError):
            main(["-1"])


class TestPackageMetadata:
    """Test package metadata and version"""
    
    def test_version_import(self):
        """Test that version can be imported"""
        from pyfs_utils import __version__
        assert __version__ is not None
        assert isinstance(__version__, str)
    
    def test_module_attributes(self):
        """Test module attributes are set correctly"""
        from pyfs_utils import skeleton
        assert hasattr(skeleton, '__author__')
        assert hasattr(skeleton, '__copyright__')
        assert hasattr(skeleton, '__license__')
        assert skeleton.__license__ == "CC0-1.0"
