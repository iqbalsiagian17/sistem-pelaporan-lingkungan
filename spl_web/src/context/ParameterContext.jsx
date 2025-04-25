import React, { createContext, useContext, useState, useEffect } from "react";
import {
  getAllParameters,
  createParameter as createParam,
  updateParameter as updateParam,
  deleteParameter as deleteParam,
} from "../services/parameterService";

const ParameterContext = createContext();

export const useParameter = () => useContext(ParameterContext);

export const ParameterProvider = ({ children }) => {
  const [parameter, setParameter] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null); // optional: for manual error handling

  const fetchParameter = async () => {
    try {
      setLoading(true);
      const result = await getAllParameters();
      setParameter(result[0] || null);
    } catch (err) {
      setError("Gagal memuat data parameter");
    } finally {
      setLoading(false);
    }
  };

  const createParameter = async (data) => {
    try {
      const created = await createParam(data);
      setParameter(created);
    } catch (err) {
      setError("Gagal membuat parameter");
    }
  };

  const updateParameter = async (data) => {
    try {
      if (!parameter?.id) throw new Error("ID parameter tidak ditemukan.");
      const updated = await updateParam(parameter.id, data);
      setParameter(updated);
    } catch (err) {
      setError("Gagal memperbarui parameter");
    }
  };
  

  const deleteParameter = async (data) => {
    try {
      if (!parameter?.id) throw new Error("ID parameter tidak ditemukan.");
      const deleted = await deleteParam();
      setParameter(deleted);
    } catch (err) {
      setError("Gagal menghapus parameter");
    }
  };

  useEffect(() => {
    fetchParameter();
  }, []);

  return (
    <ParameterContext.Provider
      value={{
        parameter,
        loading,
        error,
        createParameter,
        updateParameter,
        deleteParameter,
        fetchParameter,
      }}
    >
      {children}
    </ParameterContext.Provider>
  );
};
