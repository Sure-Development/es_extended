import '@/styles/index.css'

import { useCallback, useEffect, useMemo, useState } from 'react'
import { JSONTree } from 'react-json-tree'
import { fetchNui } from '@/utils/fetch'
import { useEvent } from '@/utils/useEvent'
import { Placement } from '@/types/Placement'
import Notification from '@/components/Notification'

type PlayerData = Record<any, any>

export default function App() {
  const [show, setShow] = useState(false)
  const [json, setJson] = useState<PlayerData>({})
  const [offset, setOffset] = useState(1)

  const offsetUnit = useMemo(() => `${offset}rem`, [offset])

  useEffect(() => {
    ;(async () => {
      const data = await fetchNui<{
        offset: number
      }>('ready')

      setOffset(data.offset)
    })()
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

      <div
        className="grid grid-cols-3 absolute top-0 left-0 w-full h-[33.34%]"
        style={{ padding: `${offsetUnit} ${offsetUnit} 0 ${offsetUnit}` }}
      >
        <div id="top-start" className="flex flex-col justify-start items-start"></div>
        <div id="top-center" className="flex flex-col justify-start items-center"></div>
        <div id="top-end" className="flex flex-col justify-start items-end"></div>
      </div>

      <div
        className="grid grid-cols-3 absolute top-1/2 -translate-y-1/2 left-0 w-full h-[33.34%]"
        style={{ padding: `0 ${offsetUnit} 0 ${offsetUnit}` }}
      >
        <div id="center-start" className="flex flex-col justify-center items-start"></div>
        <div id="center-center" className="flex flex-col justify-center items-center"></div>
        <div id="center-end" className="flex flex-col justify-center items-end"></div>
      </div>

      <div
        className="grid grid-cols-3 absolute bottom-0 left-0 w-full h-[33.34%]"
        style={{ padding: `0 ${offsetUnit} ${offsetUnit} ${offsetUnit}` }}
      >
        <div id="bottom-start" className="flex flex-col justify-end items-start"></div>
        <div id="bottom-center" className="flex flex-col justify-end items-center"></div>
        <div id="bottom-end" className="flex flex-col justify-end items-end"></div>
      </div>

      {/** Components */}
      <Notification placement={Placement.CENTER_END} />
    </>
  )
}
