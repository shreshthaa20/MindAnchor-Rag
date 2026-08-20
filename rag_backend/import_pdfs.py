# Import standard system and OS modules to manage file paths and system environments
import os
import sys
from pathlib import Path

# Append the absolute directory path of this script to sys.path.
# This ensures Python can find and import local packages (like the 'app' module)
# even when the script is run from a different working directory.
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Import LangChain's PDF loader which parses PDF files page-by-page
from langchain_community.document_loaders import PyPDFLoader
# Import the text splitter that recursively breaks down large blocks of text
# into smaller chunks using logical delimiters (newlines, paragraphs, spaces, etc.)
from langchain_text_splitters import RecursiveCharacterTextSplitter

# Import a local database helper to clear existing entries from the knowledge base table
from clear_db import clear_knowledge_base
# Import the RAG service helper that inserts text chunks, creates vector embeddings, and saves them
from app.services.rag_service import insert_knowledge_document

def process_pdfs():
    """
    Main pipeline function that:
    1. Clears existing knowledge base entries to prevent duplicates.
    2. Searches for PDF files in the designated directories.
    3. Loads and chunks the text content of each PDF.
    4. Generates embeddings and seeds the database with the document chunks.
    """
    print("WARNING: Clearing all existing knowledge base data...")
    # Clean the database knowledge base table before importing fresh documents
    clear_knowledge_base()
    print("Database cleared. Starting PDF import...")

    # Define the path to the directory containing input PDFs
    data_dir = Path("data/pdfs")
    # Verify if the PDF directory exists; if not, print a warning and exit
    if not data_dir.exists():
        print(f"Directory {data_dir} does not exist. Please create it and add PDFs.")
        return

    # Scan the directory and gather all files with a .pdf extension
    pdf_files = list(data_dir.glob("*.pdf"))
    # If the directory is empty, print a message and exit
    if not pdf_files:
        print(f"No PDF files found in {data_dir}. Please place your PDFs there.")
        return

    # Configure the character text splitter
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=1000,           # Target maximum size of each chunk (in characters)
        chunk_overlap=200,         # Overlap size (in characters) between consecutive chunks to keep context
        length_function=len,       # Use the default Python length function to count characters
        is_separator_regex=False,  # Treat separators as literal strings instead of regular expressions
    )

    # Initialize a counter for tracking the total number of chunks imported
    total_chunks = 0

    # Iterate and process each PDF file discovered in the folder
    for pdf_file in pdf_files:
        print(f"Processing {pdf_file.name}...")
        try:
            # Instantiate PyPDFLoader with the path of the current PDF file
            loader = PyPDFLoader(str(pdf_file))
            # Load and parse all pages from the PDF file
            pages = loader.load()
            
            # Split the loaded pages into chunks based on the configured chunk_size and chunk_overlap
            chunks = text_splitter.split_documents(pages)
            
            # Loop through each generated chunk to save it to the database
            for chunk in chunks:
                # Extract the raw text content of the current chunk
                content = chunk.page_content
                # Retrieve the original source information, noting the page number (0-indexed)
                source = f"{pdf_file.name} (Page {chunk.metadata.get('page', 'unknown')})"
                # Derive a user-friendly title from the PDF file name (replace separators with spaces and title case)
                title = pdf_file.name.replace(".pdf", "").replace("_", " ").replace("-", " ").title()
                
                # Insert the chunk into the database.
                # Setting user_id to None makes this document globally accessible to all users.
                insert_knowledge_document(
                    user_id=None,               # Global knowledge base context
                    title=title,                # Document title
                    content=content,            # Text chunk content
                    source=source,              # Document source with page metadata
                    category="Curated Knowledge", # Grouping category
                    tags=["pdf_import"]         # Searchable tag identifier
                )
                total_chunks += 1
            print(f"Finished {pdf_file.name}. Generated {len(chunks)} chunks.")
        except Exception as e:
            # Catch and log any errors that occur during the processing of a single PDF file
            print(f"Error processing {pdf_file.name}: {e}")

    print(f"Successfully imported all PDFs! Total chunks generated and stored: {total_chunks}")

# Check if the script is executed directly (rather than imported) and run the pipeline
if __name__ == "__main__":
    process_pdfs()
