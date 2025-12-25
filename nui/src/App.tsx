import { useCallback, useEffect, useState } from 'react'
import { JSONTree } from 'react-json-tree'
import { fetchNui } from './utils/fetch'
import { useEvent } from './utils/useEvent'

type PlayerData = Record<any, any>

export default function App() {
  const [show, setShow] = useState(false)
  const [json, setJson] = useState<PlayerData>({})
  
  useEffect(() => {
    fetchNui('ready')
  }, [])

  useEvent<boolean>('toggle', (value) => setShow(value))
  useEvent<PlayerData>('update', (value) => setJson(value))

  const handleKeyboard = useCallback((e: KeyboardEvent) => {
    if (e.code === 'Escape') {
      fetchNui('close')
    }
  }, [])

  useEffect(() => {
    document.addEventListener('keydown', handleKeyboard)
    return () => {
      document.removeEventListener('keydown', handleKeyboard)
    }
  }, [handleKeyboard])

  return (
    <>
      <div
        style={{
          opacity: show ? 1 : 0,
          width: 600,
        }}
      >
        <JSONTree data={json} />
      </div>
    </>
  )
}
