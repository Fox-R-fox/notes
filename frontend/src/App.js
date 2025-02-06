import React, { useState, useEffect } from 'react';
import axios from 'axios';

function App() {
  const [notes, setNotes] = useState([]);
  const [newNote, setNewNote] = useState('');

  useEffect(() => {
    fetchNotes();
  }, []);

  const fetchNotes = async () => {
    const response = await axios.get('/api/notes');
    setNotes(response.data);
  };

  const addNote = async () => {
    await axios.post('/api/notes', { text: newNote });
    setNewNote('');
    fetchNotes();
  };

  return (
    <div>
      <h1>My Notes</h1>
      <ul>
        {notes.map((note, index) => (
          <li key={index}>{note.text}</li>
        ))}
      </ul>
      <input
        type="text"
        value={newNote}
        onChange={(e) => setNewNote(e.target.value)}
      />
      <button onClick={addNote}>Add Note</button>
    </div>
  );
}

export default App;