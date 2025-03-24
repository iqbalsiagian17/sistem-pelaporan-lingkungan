import { useState } from "react";
import CarouselTable from "./components/CarouselTable";
import CarouselCreateModal from "./components/CreateCarouselModal";
import CarouselEditModal from "./components/EditCarouselModal";
import CarouselDeleteModal from "./components/DeleteCarouselModal";
import CarouselDetailModal from "./components/DetailCarouselModal";
import { useCarousel } from "../../context/CarouselContext";

const CarouselPage = () => {
  const {
    carousels,
    getCarouselById,
    addCarousel,
    updateCarousel,
    deleteCarousel,
  } = useCarousel();

  const [selectedCarousel, setSelectedCarousel] = useState(null);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showDetailModal, setShowDetailModal] = useState(false);

  const handleOpenDetailModal = async (id) => {
    try {
      const data = await getCarouselById(id);
      setSelectedCarousel(data);
      setShowDetailModal(true);
    } catch (err) {
      alert(`❌ Gagal memuat detail: ${err.message}`);
    }
  };

  const handleOpenEditModal = (carousel) => {
    setSelectedCarousel(carousel);
    setShowEditModal(true);
  };

  const handleOpenDeleteModal = (carousel) => {
    setSelectedCarousel(carousel);
    setShowDeleteModal(true);
  };

  const handleCreate = async (formData) => {
    try {
      await addCarousel(formData);
      setShowCreateModal(false);
    } catch (err) {
      alert(`❌ Gagal menambahkan: ${err.message}`);
    }
  };

  const handleSaveEdit = async (id, formData) => {
    try {
      await updateCarousel(id, formData);
      setShowEditModal(false);
    } catch (err) {
      alert(`❌ Gagal mengubah data: ${err.message}`);
    }
  };

  const handleConfirmDelete = async () => {
    try {
      await deleteCarousel(selectedCarousel.id);
      setShowDeleteModal(false);
    } catch (err) {
      alert(`❌ Gagal menghapus: ${err.message}`);
    }
  };

  return (
    <>
      <div className="d-flex justify-content-end mb-3">
        <button className="btn btn-primary" onClick={() => setShowCreateModal(true)}>
          + Tambah Carousel
        </button>
      </div>

      <CarouselTable
        carousels={carousels}
        onView={handleOpenDetailModal}
        onEdit={handleOpenEditModal}
        onDelete={handleOpenDeleteModal}
      />

      <CarouselCreateModal
        show={showCreateModal}
        onHide={() => setShowCreateModal(false)}
        onCreate={handleCreate}
      />

      <CarouselEditModal
        show={showEditModal}
        onHide={() => setShowEditModal(false)}
        carousel={selectedCarousel}
        onSave={handleSaveEdit}
      />

      <CarouselDeleteModal
        show={showDeleteModal}
        onHide={() => setShowDeleteModal(false)}
        onConfirm={handleConfirmDelete}
      />

      <CarouselDetailModal
        show={showDetailModal}
        onHide={() => setShowDetailModal(false)}
        carousel={selectedCarousel}
      />
    </>
  );
};

export default CarouselPage;
